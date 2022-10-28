LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY 7SegEncoder IS
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
END vga_controller;

ARCHITECTURE behavior OF vga_controller IS

	constant h_pulse  : INTEGER := 144;    --horiztonal sync pulse width in pixels
	constant h_bp     : INTEGER := 248;    --horiztonal back porch width in pixels
	constant h_pixels : INTEGER := 1280;   --horiztonal display width in pixels
	constant h_fp     : INTEGER := 16;    --horiztonal front porch width in pixels
	constant h_pol    : STD_LOGIC := '1';  --horizontal sync pulse polarity (1 = positive, 0 = negative)
	constant v_pulse  : INTEGER := 3;      --vertical sync pulse width in rows
	constant v_bp     : INTEGER := 38;     --vertical back porch width in rows
	constant v_pixels : INTEGER := 1024;   --vertical display width in rows
	constant v_fp     : INTEGER := 1;      --vertical front porch width in rows
	constant v_pol    : STD_LOGIC := '1'; --vertical sync pulse polarity (1 = positive, 0 = negative)
	
	constant h_period : INTEGER := h_pulse + h_bp + h_pixels + h_fp; --total number of pixel clocks in a row
	constant v_period : INTEGER := v_pulse + v_bp + v_pixels + v_fp; --total number of rows in column
BEGIN