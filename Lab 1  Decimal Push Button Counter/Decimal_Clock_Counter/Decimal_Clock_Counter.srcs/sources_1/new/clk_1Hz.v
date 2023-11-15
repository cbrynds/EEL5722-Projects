`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/09/2023 08:29:54 PM
// Design Name: 
// Module Name: clk_1Hz
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


module clk_1Hz(
    input clkIn,
    output reg clkOut
    );
    
    reg[26:0] N; // Value to divide clock, calculated by fout = fin/(2*N) 
    always @ (posedge clkIn) begin
        if (N == 50000000) begin
            clkOut <= ~clkOut;
            N <= 26'b0;
        end
        else 
            N= N + 1'b1;
    end
endmodule
5387541
