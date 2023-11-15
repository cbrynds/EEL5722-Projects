`timescale 1ns / 1ps

module seven_segment_controller(
        input clk,
        input [3:0] ones,
        output [6:0] seg,
        output [3:0] an
    );
    
    wire [6:0] seg1;

    seven_segment_converter ones_converter(.dec(ones), .seg(seg1));
    
    assign seg = seg1;
    assign an = 4'b1110;
    
endmodule
