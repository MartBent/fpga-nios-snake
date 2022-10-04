	component system is
		port (
			blue_pio_export  : out std_logic_vector(7 downto 0);                     -- export
			btn_pio_export   : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			clk_clk          : in  std_logic                     := 'X';             -- clk
			green_pio_export : out std_logic_vector(7 downto 0);                     -- export
			mem_address      : in  std_logic_vector(18 downto 0) := (others => 'X'); -- address
			mem_chipselect   : in  std_logic                     := 'X';             -- chipselect
			mem_clken        : in  std_logic                     := 'X';             -- clken
			mem_write        : in  std_logic                     := 'X';             -- write
			mem_readdata     : out std_logic_vector(7 downto 0);                     -- readdata
			mem_writedata    : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- writedata
			red_pio_export   : out std_logic_vector(7 downto 0);                     -- export
			reset_reset_n    : in  std_logic                     := 'X'              -- reset_n
		);
	end component system;

	u0 : component system
		port map (
			blue_pio_export  => CONNECTED_TO_blue_pio_export,  --  blue_pio.export
			btn_pio_export   => CONNECTED_TO_btn_pio_export,   --   btn_pio.export
			clk_clk          => CONNECTED_TO_clk_clk,          --       clk.clk
			green_pio_export => CONNECTED_TO_green_pio_export, -- green_pio.export
			mem_address      => CONNECTED_TO_mem_address,      --       mem.address
			mem_chipselect   => CONNECTED_TO_mem_chipselect,   --          .chipselect
			mem_clken        => CONNECTED_TO_mem_clken,        --          .clken
			mem_write        => CONNECTED_TO_mem_write,        --          .write
			mem_readdata     => CONNECTED_TO_mem_readdata,     --          .readdata
			mem_writedata    => CONNECTED_TO_mem_writedata,    --          .writedata
			red_pio_export   => CONNECTED_TO_red_pio_export,   --   red_pio.export
			reset_reset_n    => CONNECTED_TO_reset_reset_n     --     reset.reset_n
		);

