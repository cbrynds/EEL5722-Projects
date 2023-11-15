`timescale 1ns / 1ps

module seven_segment_controller(
        input clk,
        input [3:0] digit,
        output [6:0] seg,
        output [3:0] an
    );

    seven_segment_converter scan2dec(.dec(digit), .seg(seg));

    assign an = 4'b1110;
    
endmodule
