LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY vga_controller IS
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

  n_blank <= '1';  --no direct blanking
  n_sync <= '0';   --no sync on green
  
  PROCESS(pixel_clk, reset_n)
    VARIABLE h_count : INTEGER RANGE 0 TO h_period - 1 := 0;  --horizontal counter (counts the columns)
    VARIABLE v_count : INTEGER RANGE 0 TO v_period - 1 := 0;  --vertical counter (counts the rows)
  BEGIN
  
    IF(reset_n = '0') THEN    --reset asserted
      h_count := 0;             --reset horizontal counter
      v_count := 0;             --reset vertical counter
      h_sync <= NOT h_pol;      --deassert horizontal sync
      v_sync <= NOT v_pol;      --deassert vertical sync
      disp_ena <= '0';          --disable display
      column <= 0;              --reset column pixel coordinate
      row <= 0;                 --reset row pixel coordinate
      
    ELSIF(pixel_clk'EVENT AND pixel_clk = '1') THEN

      --counters
      IF(h_count < h_period - 1) THEN    --horizontal counter (pixels)
        h_count := h_count + 1;
      ELSE
        h_count := 0;
        IF(v_count < v_period - 1) THEN  --veritcal counter (rows)
          v_count := v_count + 1;
        ELSE
          v_count := 0;
        END IF;
      END IF;

      --horizontal sync signal
      IF(h_count < h_pixels + h_fp OR h_count >= h_pixels + h_fp + h_pulse) THEN
        h_sync <= NOT h_pol;    --deassert horiztonal sync pulse
      ELSE
        h_sync <= h_pol;        --assert horiztonal sync pulse
      END IF;
      
      --vertical sync signal
      IF(v_count < v_pixels + v_fp OR v_count >= v_pixels + v_fp + v_pulse) THEN
        v_sync <= NOT v_pol;    --deassert vertical sync pulse
      ELSE
        v_sync <= v_pol;        --assert vertical sync pulse
      END IF;
      
      --set pixel coordinates
      IF(h_count < h_pixels) THEN  --horiztonal display time
        column <= h_count;           --set horiztonal pixel coordinate
      END IF;
      IF(v_count < v_pixels) THEN  --vertical display time
        row <= v_count;              --set vertical pixel coordinate
      END IF;

      --set display enable output
      IF(h_count < h_pixels AND v_count < v_pixels) THEN  
        disp_ena <= '1';
      ELSE                                                
        disp_ena <= '0';	  
      END IF;

    END IF;
  END PROCESS;

END behavior;