
module system (
	blue_pio_export,
	btn_pio_export,
	clk_clk,
	green_pio_export,
	mem_address,
	mem_chipselect,
	mem_clken,
	mem_write,
	mem_readdata,
	mem_writedata,
	mem_byteenable,
	red_pio_export,
	reset_reset_n);	

	output	[7:0]	blue_pio_export;
	input	[3:0]	btn_pio_export;
	input		clk_clk;
	output	[7:0]	green_pio_export;
	input	[16:0]	mem_address;
	input		mem_chipselect;
	input		mem_clken;
	input		mem_write;
	output	[31:0]	mem_readdata;
	input	[31:0]	mem_writedata;
	input	[3:0]	mem_byteenable;
	output	[7:0]	red_pio_export;
	input		reset_reset_n;
endmodule
