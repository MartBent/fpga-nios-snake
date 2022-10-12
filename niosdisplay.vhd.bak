LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--if(offset = 32768)then 
--frame_buf_addr <= std_logic_vector(unsigned(frame_buf_addr_base) + offset); --Increment the address one clock cycle before last byte is red, since reading is delay by 1.
					

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
		blue_pio_export  : out std_logic_vector(7 downto 0);                    --  blue_pio.export
		btn_pio_export   : in  std_logic_vector(3 downto 0) := (others => '0'); --   btn_pio.export
		clk_clk          : in  std_logic                    := '0';             --       clk.clk
		green_pio_export : out std_logic_vector(7 downto 0);                    -- green_pio.export
		red_pio_export   : out std_logic_vector(7 downto 0);                    --   red_pio.export
		reset_reset_n    : in  std_logic                    := '0';              --     reset.reset_n
		mem_address      : in  std_logic_vector(16 downto 0) := (others => '0');
		mem_readdata     : out std_logic_vector(31 downto 0)                 
	);
END COMPONENT system;

type ram_array is array (0 to 262144) of std_logic_vector (7 downto 0);

signal x : integer := 478;
signal y : integer := 600;

signal GND : std_logic := '0';
signal VCC : std_logic := '1';
signal clk_138 : std_logic;
signal column : integer;
signal row : integer;
signal disp_ena : std_logic;

signal red_pio : std_logic_vector(7 downto 0);
signal green_pio : std_logic_vector(7 downto 0);
signal blue_pio : std_logic_vector(7 downto 0);
signal mem_data : std_logic_vector(31 downto 0);

signal frame_buf_addr_base : std_logic_vector(16 downto 0) := "00011101000011000";--"00111010100110000";
signal frame_buf_addr : std_logic_vector(16 downto 0) := "00000000000000000";
signal data_ready : std_logic := '0';

BEGIN
	GND <= '0';
	VCC <= '1';
	
	u0: altpll0 port map(GND, clk, clk_138);
	u1: vga_controller port map(clk_138, VCC, h_sync,v_sync, disp_ena, column, row, n_blank, n_sync);
	u2: system port map(blue_pio, btn, clk_138, green_pio, red_pio, VCC, frame_buf_addr, mem_data);
	
	pixel_clk <= clk_138;
	
	PROCESS(clk_138, disp_ena, row, column, x, y, key)
	variable count : integer := 0;
	variable offset : integer := 0;
	
	BEGIN
	IF(rising_edge(clk_138)) then
		IF(disp_ena = '1') then
			IF((row > 256) and (row < 256+512) and (column > 320) and (column < 320+512)) THEN --Inside game screen
				if(count = 0) THEN
					red <= mem_data(31 downto 24);
					blue <= mem_data(31 downto 24);
					green <= mem_data(31 downto 24);
					count := count + 1;
				elsif(count = 1) THEN
					red <= mem_data(23 downto 16);
					green <= mem_data(23 downto 16);
					blue <= mem_data(23 downto 16);
					count := count + 1;
				elsif(count = 2) THEN
					red <= mem_data(15 downto 8);
					green <= mem_data(15 downto 8);
					blue <= mem_data(15 downto 8);
					count := count + 1;
				elsif(count = 3) THEN
					red <= mem_data(7 downto 0);
					green <= mem_data(7 downto 0);
					blue <= mem_data(7 downto 0);
					count := 0;
				elsif(count = 5) then
					red <= mem_data(31 downto 24);
					green <= mem_data(31 downto 24);
					blue <= mem_data(31 downto 24);
				end if;
			ELSE --Gray color to boundary
				red <= "11111001";
				green <= "10101001";
				blue <= "10101001";
			END IF;
		ELSE					
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		END IF;
	END IF;
	END PROCESS;
END behavior;