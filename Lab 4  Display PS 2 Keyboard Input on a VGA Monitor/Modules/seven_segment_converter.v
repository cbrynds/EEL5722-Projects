`timescale 1ns / 1ps

module seven_segment_converter(
    input [3:0] dec,
    output reg [6:0] seg
);
    
    always @ (*) begin
        case (dec)
        4'b0000: seg = 7'b1000000; // or 7'h3F
        4'b0001: seg = 7'b1111001; // or 7'h06
        4'b0010: seg = 7'b0100100; // or 7'h5B
        4'b0011: seg = 7'b0110000; // or 7'h4F
        4'b0100: seg = 7'b0011001; // or 7'h66
        4'b0101: seg = 7'b0010010; // or 7'h6D
        4'b0110: seg = 7'b0000010; // or 7'h7D
        4'b0111: seg = 7'b1111000; // or 7'h07
        4'b1000: seg = 7'b0000000; // or 7'h7F
        4'b1001: seg = 7'b0010000; // or 7'h4F
        default: seg = 7'b1111111;
        endcase
    end
endmodule
