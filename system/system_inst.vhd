	component system is
		port (
			btn_pio_export       : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			clk_clk              : in  std_logic                     := 'X';             -- clk
			frame_buf_address    : in  std_logic_vector(16 downto 0) := (others => 'X'); -- address
			frame_buf_chipselect : in  std_logic                     := 'X';             -- chipselect
			frame_buf_clken      : in  std_logic                     := 'X';             -- clken
			frame_buf_write      : in  std_logic                     := 'X';             -- write
			frame_buf_readdata   : out std_logic_vector(31 downto 0);                    -- readdata
			frame_buf_writedata  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			frame_buf_byteenable : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			reset_reset_n        : in  std_logic                     := 'X'              -- reset_n
		);
	end component system;

	u0 : component system
		port map (
			btn_pio_export       => CONNECTED_TO_btn_pio_export,       --   btn_pio.export
			clk_clk              => CONNECTED_TO_clk_clk,              --       clk.clk
			frame_buf_address    => CONNECTED_TO_frame_buf_address,    -- frame_buf.address
			frame_buf_chipselect => CONNECTED_TO_frame_buf_chipselect, --          .chipselect
			frame_buf_clken      => CONNECTED_TO_frame_buf_clken,      --          .clken
			frame_buf_write      => CONNECTED_TO_frame_buf_write,      --          .write
			frame_buf_readdata   => CONNECTED_TO_frame_buf_readdata,   --          .readdata
			frame_buf_writedata  => CONNECTED_TO_frame_buf_writedata,  --          .writedata
			frame_buf_byteenable => CONNECTED_TO_frame_buf_byteenable, --          .byteenable
			reset_reset_n        => CONNECTED_TO_reset_reset_n         --     reset.reset_n
		);

