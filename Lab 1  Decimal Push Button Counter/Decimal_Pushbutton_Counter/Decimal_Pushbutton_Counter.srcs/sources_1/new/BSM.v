`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2023 12:40:16 PM
// Design Name: 
// Module Name: CSM
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

module one_second_counter(
    input clk_1Hz,
    output reg [3:0] dec1, dec2
);

always @ (posedge clk_1Hz) begin
    if (dec2 == 9)
        dec1 <= (dec1 + 1'b1) % 10;
    dec2 <= (dec2 + 1'b1) % 10;
end

endmodule