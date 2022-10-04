-- Copyright (C) 2021  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "09/20/2022 13:11:45"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          niosdisplay
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY niosdisplay_vhd_vec_tst IS
END niosdisplay_vhd_vec_tst;
ARCHITECTURE niosdisplay_arch OF niosdisplay_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL B_external : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL BLANK_external : STD_LOGIC;
SIGNAL CLK_25 : STD_LOGIC;
SIGNAL G_External : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL HSYNC_external : STD_LOGIC;
SIGNAL KEY : STD_LOGIC;
SIGNAL LED : STD_LOGIC;
SIGNAL R_external : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL RST_external : STD_LOGIC;
SIGNAL SYNC_external : STD_LOGIC;
SIGNAL VCLK_external : STD_LOGIC;
SIGNAL VSYNC_external : STD_LOGIC;
COMPONENT niosdisplay
	PORT (
	B_external : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	BLANK_external : OUT STD_LOGIC;
	CLK_25 : IN STD_LOGIC;
	G_External : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	HSYNC_external : OUT STD_LOGIC;
	KEY : IN STD_LOGIC;
	LED : OUT STD_LOGIC;
	R_external : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	RST_external : IN STD_LOGIC;
	SYNC_external : OUT STD_LOGIC;
	VCLK_external : OUT STD_LOGIC;
	VSYNC_external : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : niosdisplay
	PORT MAP (
-- list connections between master ports and signals
	B_external => B_external,
	BLANK_external => BLANK_external,
	CLK_25 => CLK_25,
	G_External => G_External,
	HSYNC_external => HSYNC_external,
	KEY => KEY,
	LED => LED,
	R_external => R_external,
	RST_external => RST_external,
	SYNC_external => SYNC_external,
	VCLK_external => VCLK_external,
	VSYNC_external => VSYNC_external
	);

-- CLK_25
t_prcs_CLK_25: PROCESS
BEGIN
LOOP
	CLK_25 <= '0';
	WAIT FOR 10000 ps;
	CLK_25 <= '1';
	WAIT FOR 10000 ps;
	IF (NOW >= 100000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_CLK_25;

-- KEY
t_prcs_KEY: PROCESS
BEGIN
	KEY <= '0';
WAIT;
END PROCESS t_prcs_KEY;

-- RST_external
t_prcs_RST_external: PROCESS
BEGIN
	RST_external <= 'H';
WAIT;
END PROCESS t_prcs_RST_external;
END niosdisplay_arch;
