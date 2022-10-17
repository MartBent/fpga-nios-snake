
module system (
	btn_pio_export,
	clk_clk,
	frame_buf_address,
	frame_buf_chipselect,
	frame_buf_clken,
	frame_buf_write,
	frame_buf_readdata,
	frame_buf_writedata,
	frame_buf_byteenable,
	reset_reset_n);	

	input	[3:0]	btn_pio_export;
	input		clk_clk;
	input	[16:0]	frame_buf_address;
	input		frame_buf_chipselect;
	input		frame_buf_clken;
	input		frame_buf_write;
	output	[31:0]	frame_buf_readdata;
	input	[31:0]	frame_buf_writedata;
	input	[3:0]	frame_buf_byteenable;
	input		reset_reset_n;
endmodule
