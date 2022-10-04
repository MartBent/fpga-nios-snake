	system u0 (
		.blue_pio_export  (<connected-to-blue_pio_export>),  //  blue_pio.export
		.btn_pio_export   (<connected-to-btn_pio_export>),   //   btn_pio.export
		.clk_clk          (<connected-to-clk_clk>),          //       clk.clk
		.green_pio_export (<connected-to-green_pio_export>), // green_pio.export
		.mem_address      (<connected-to-mem_address>),      //       mem.address
		.mem_chipselect   (<connected-to-mem_chipselect>),   //          .chipselect
		.mem_clken        (<connected-to-mem_clken>),        //          .clken
		.mem_write        (<connected-to-mem_write>),        //          .write
		.mem_readdata     (<connected-to-mem_readdata>),     //          .readdata
		.mem_writedata    (<connected-to-mem_writedata>),    //          .writedata
		.red_pio_export   (<connected-to-red_pio_export>),   //   red_pio.export
		.reset_reset_n    (<connected-to-reset_reset_n>)     //     reset.reset_n
	);

