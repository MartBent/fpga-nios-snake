	system u0 (
		.btn_pio_export       (<connected-to-btn_pio_export>),       //   btn_pio.export
		.clk_clk              (<connected-to-clk_clk>),              //       clk.clk
		.frame_buf_address    (<connected-to-frame_buf_address>),    // frame_buf.address
		.frame_buf_chipselect (<connected-to-frame_buf_chipselect>), //          .chipselect
		.frame_buf_clken      (<connected-to-frame_buf_clken>),      //          .clken
		.frame_buf_write      (<connected-to-frame_buf_write>),      //          .write
		.frame_buf_readdata   (<connected-to-frame_buf_readdata>),   //          .readdata
		.frame_buf_writedata  (<connected-to-frame_buf_writedata>),  //          .writedata
		.frame_buf_byteenable (<connected-to-frame_buf_byteenable>), //          .byteenable
		.reset_reset_n        (<connected-to-reset_reset_n>)         //     reset.reset_n
	);

