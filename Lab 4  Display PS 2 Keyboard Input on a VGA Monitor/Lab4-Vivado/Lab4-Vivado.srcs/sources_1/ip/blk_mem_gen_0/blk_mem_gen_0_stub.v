// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Wed Nov 15 10:19:43 2023
// Host        : Cory-Desktop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {g:/My Drive/Classes/Fall 2023/FPGA Design/EEL5722-Projects/Lab 4
//               Display PS 2 Keyboard Input on a VGA
//               Monitor/Lab4-Vivado/Lab4-Vivado.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_stub.v}
// Design      : blk_mem_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2017.4" *)
module blk_mem_gen_0(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[10:0],douta[23:0]" */;
  input clka;
  input [10:0]addra;
  output [23:0]douta;
endmodule
