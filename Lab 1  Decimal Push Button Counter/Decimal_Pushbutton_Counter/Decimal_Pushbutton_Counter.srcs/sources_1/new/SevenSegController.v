`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2023 12:40:16 PM
// Design Name: 
// Module Name: SevenSegController
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


module seven_seg_controller(
        input clk,
        input [3:0] dec1, dec2,
        output reg [6:0] seg,
        output [3:0] an
    );
    
    wire seg_select, clk_100Hz;
    wire [6:0] seg1, seg2;
    
    seven_seg_converter tens_converter(.dec(dec1), .seg(seg1));
    seven_seg_converter ones_converter(.dec(dec2), .seg(seg2));
    clk_100Hz seg_clk_divider(.clkIn(clk), .clkOut(clk_100Hz));
    seven_segment_display display(.clk_100Hz(clk_100Hz), .an(an));
    
    assign seg_select = (an == 4'b1101) ? 1'b0: 1'b1;
    
    always @ (posedge clk_100Hz) begin
        case (seg_select)
            1'b0: 
                seg <= seg2;
            1'b1: 
                seg <= seg1;
        endcase
    end
    
endmodule
