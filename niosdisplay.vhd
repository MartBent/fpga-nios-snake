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
		n_sync  	  	: OUT  STD_LOGIC;
		out_frame_buf_addr : OUT STD_LOGIC_VECTOR(16 downto 0);
		out_mem_data : OUT STD_LOGIC_VECTOR(31 downto 0)
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
		btn_pio_export   : in  std_logic_vector(3 downto 0) := (others => '0'); --   btn_pio.export
		clk_clk          : in  std_logic                    := '0';             --       clk.clk
		reset_reset_n    : in  std_logic                    := '0';              --     reset.reset_n
		mem_address      : in  std_logic_vector(16 downto 0) := (others => '0');
		mem_readdata     : out std_logic_vector(31 downto 0)
	);
END COMPONENT system;

--VGA Stuff
signal clk_138 : std_logic;
signal column : integer;
signal row : integer;
signal disp_ena : std_logic;

--Nios II Stuff
signal mem_data : std_logic_vector(31 downto 0);
signal frame_buf_addr_base : std_logic_vector(16 downto 0) := "00011101000011000";--"00111010100110000";
signal frame_buf_addr : natural range 14872 to 80407 := 14872;

BEGIN
	
	u0: altpll0 port map('0', clk, clk_138);
	u1: vga_controller port map(clk_138, '1', h_sync,v_sync, disp_ena, column, row, n_blank, n_sync);
	u2: system port map(btn, clk_138, '1', std_logic_vector(to_unsigned(frame_buf_addr, frame_buf_addr_base'length)), mem_data);
	
	out_frame_buf_addr <= std_logic_vector(to_unsigned(frame_buf_addr, frame_buf_addr_base'length));
	out_mem_data <= mem_data;
	pixel_clk <= clk_138;
	
	draw_pixel : PROCESS(clk_138)
	
	variable count : natural range 0 to 4 := 0;
	
	BEGIN
	IF rising_edge(clk_138) then
		IF disp_ena = '1' then
			--IF((row > 256) and (row < 256+512) and (column > 320) and (column < 320+512)) THEN --Inside game screen
				case count is
					when 0 =>
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
						if(frame_buf_addr = 14872+65535) then
						frame_buf_addr <= 14872;
						else
							frame_buf_addr <= frame_buf_addr + 1;
						end if;
					when 3 =>
						red <= mem_data(7 downto 0);
						green <= mem_data(7 downto 0);
						blue <= mem_data(7 downto 0);
						count := 0;
					when others =>
						red <= mem_data(31 downto 24);
						green <= mem_data(31 downto 24);
						blue <= mem_data(31 downto 24);					
				end case;
			--ELSE --Gray color to boundary
				--red <= "11111001";
				--green <= "10101001";
				--blue <= "10101001";
			--END IF;
		ELSE					
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		END IF;
	END IF;
	END PROCESS;
END behavior;