LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY niosdisplay IS
	PORT(
		clk			:  IN  	STD_LOGIC;
		key			:  IN 	STD_LOGIC;
		pixel_clk   :  OUT   STD_LOGIC;
		red			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '1');  --red magnitude output to DAC
		green			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '1');  --green magnitude output to DAC
		blue			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '1'); --blue magnitude output to DAC
		btn			:	IN	STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0'); --btn pio
		h_sync    	: OUT  STD_LOGIC;
		v_sync    	: OUT  STD_LOGIC;
		n_blank     : OUT  STD_LOGIC;
		n_sync  	  	: OUT  STD_LOGIC
		);
END niosdisplay;

ARCHITECTURE behavior OF niosdisplay IS
COMPONENT vga_controller IS
  PORT(
    pixel_clk : IN   STD_LOGIC;  --pixel clock at frequency of VGA mode being used
    reset_n   : IN   STD_LOGIC;  --active low asycnchronous reset
    h_sync    : OUT  STD_LOGIC;  --horiztonal sync pulse
    v_sync    : OUT  STD_LOGIC;  --vertical sync pulse
    disp_ena  : OUT  STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
    column    : OUT  INTEGER;    --horizontal pixel coordinate
    row       : OUT  INTEGER;    --vertical pixel coordinate
    n_blank   : OUT  STD_LOGIC;  --direct blacking output to DAC
    n_sync    : OUT  STD_LOGIC --sync-on-green output to DAC
	 );
END COMPONENT vga_controller;
COMPONENT altpll0 IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0				: OUT STD_LOGIC
	);
END COMPONENT altpll0;

COMPONENT system is
	port (
		btn_pio_export       : in  std_logic_vector(3 downto 0)  := (others => '0'); --   btn_pio.export
		clk_clk              : in  std_logic                     := '0';             --       clk.clk
		frame_buf_address    : in  std_logic_vector(16 downto 0) := (others => '0'); -- frame_buf.address
		frame_buf_chipselect : in  std_logic                     := '0';             --          .chipselect
		frame_buf_clken      : in  std_logic                     := '0';             --          .clken
		frame_buf_write      : in  std_logic                     := '0';             --          .write
		frame_buf_readdata   : out std_logic_vector(31 downto 0);                    --          .readdata
		frame_buf_writedata  : in  std_logic_vector(31 downto 0) := (others => '0'); --          .writedata
		frame_buf_byteenable : in  std_logic_vector(3 downto 0)  := (others => '0'); --          .byteenable
		reset_reset_n        : in  std_logic                     := '0'              --     reset.reset_n
	);
END COMPONENT system;

--VGA Stuff
signal clk_138 : std_logic;
signal column : integer;
signal row : integer;
signal disp_ena : std_logic;

--Nios II Stuff
signal mem_data : std_logic_vector(31 downto 0) := (others => '0');
signal frame_buf_addr : natural range 0 to 65536 := 0;
signal frame_buf_cs : std_logic := '0';
signal frame_buf_byte_enable : std_logic_vector(3 downto 0) := "0000";
signal frame_buf_addr_vec : std_logic_vector(16 downto 0) := "00000000000000000";

BEGIN
	
	u0: altpll0 port map('0', clk, clk_138);
	u1: vga_controller port map(clk_138, '1', h_sync,v_sync, disp_ena, column, row, n_blank, n_sync);
	u2: system port map(btn_pio_export => btn, 
							  clk_clk => clk_138, 
							  reset_reset_n => '1', 
							  frame_buf_clken => '1',
							  frame_buf_address => frame_buf_addr_vec, 
							  frame_buf_readdata => mem_data,
							  frame_buf_chipselect => frame_buf_cs,
							  frame_buf_byteenable => frame_buf_byte_enable
							  );
	
	pixel_clk <= clk_138;
	
	draw_pixel : PROCESS(clk_138)
	
	variable count : natural range 0 to 4 := 0;
	variable busy : std_logic := '0';
	
	BEGIN
	IF rising_edge(clk_138) then
	
		frame_buf_cs <= '0';
		
		if(row = 256 and column = 320) then --Reset pixel
			frame_buf_cs <= '1';
			frame_buf_byte_enable <= "1111";
			frame_buf_addr <= 0;
			frame_buf_addr_vec <= std_logic_vector(to_unsigned(frame_buf_addr, 17));
			count := 0;
		end if;
		
		IF disp_ena = '1' then
			IF((row > 255) and (row < 255+513) and (column > 319) and (column < 319+513)) THEN --Inside game screen
				case count is
					when 0 =>
						frame_buf_byte_enable <= "0000";
						red <= mem_data(31 downto 24);
						blue <= mem_data(31 downto 24);
						green <= mem_data(31 downto 24);
						count := 1;	
					when 1 =>
						red <= mem_data(23 downto 16);
						green <= mem_data(23 downto 16);
						blue <= mem_data(23 downto 16);
						count := 2;	
					when 2 =>
						red <= mem_data(15 downto 8);
						green <= mem_data(15 downto 8);
						blue <= mem_data(15 downto 8);
						count := 3;
						
						frame_buf_cs <= '1';
						frame_buf_byte_enable <= "1111";
					
						frame_buf_addr <= frame_buf_addr + 1;
						frame_buf_addr_vec <= std_logic_vector(to_unsigned(frame_buf_addr, 17));
					when 3 =>
						red <= mem_data(7 downto 0);	
						green <= mem_data(7 downto 0);
						blue <= mem_data(7 downto 0);
						count := 0;
					when others =>
						red <= (OTHERS => '0');
						green <= (OTHERS => '0');
						blue <= (OTHERS => '0');				
				end case;
			ELSE --Gray color to boundary
				red <= "11111001";
				green <= "10101001";
				blue <= "10101001";
			END IF;
		ELSE					
			frame_buf_byte_enable <= "0000"; --Needed for when the last word of a row is read out.
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		END IF;
	END IF;
	END PROCESS;
END behavior;