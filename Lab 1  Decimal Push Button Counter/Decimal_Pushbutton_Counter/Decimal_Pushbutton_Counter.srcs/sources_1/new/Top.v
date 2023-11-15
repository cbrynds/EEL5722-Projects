`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2023 12:40:16 PM
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
    input clk,
    output [6:0] seg,
    output [3:0] an
);
    wire [3:0] tens, ones;
    wire clk_1Hz;
    
    seven_seg_controller seg_ctrl (.clk(clk), .dec1(tens), .dec2(ones), .an(an), .seg(seg));
    CSM clock_state_machine(.clk_1Hz(clk_1Hz), .dec1(tens), .dec2(ones));
    clk_1Hz dec_clk_divider(.clkIn(clk), .clkOut(clk_1Hz));
    
    
endmodule
