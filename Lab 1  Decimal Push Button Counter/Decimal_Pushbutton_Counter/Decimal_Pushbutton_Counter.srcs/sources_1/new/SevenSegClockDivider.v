`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2023 12:40:16 PM
// Design Name: 
// Module Name: SevenSegClockDivider
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


module clk_100Hz(
    input clkIn,
    output reg clkOut
    );
    
    reg[19:0] N; // Value to divide clock, calculated by fout = fin/(2*N) 
    always @ (posedge clkIn) begin
        if (N == 500000) begin
            clkOut <= ~clkOut;
            N <= 20'b0;
        end
        else 
            N= N + 1'b1;
    end
endmodule
