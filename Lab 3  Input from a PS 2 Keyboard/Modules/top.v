module top(
    input clk, PS2clk, key_data,
    output [6:0] seg,
    output [3:0] an
);

reg[3:0] dec;
wire[7:0] c_data;

PS2_receiver receiver(
    .clk(clk), 
    .key_data(key_data), 
    .c_data(c_data)
    );
seven_segment_controller controller(
    .clk(clk),
    .digit(dec),
    .seg(seg),
    .an(an)
    )

always @ (c_data) begin
    case (key_data)
        8'h45: 
            dec = 0;
        8'h16:
            dec = 1;
        8'h1E:
            dec = 2;
        8'h26:
            dec = 3;
        8'h25:
            dec = 4;
        8'h2E:
            dec = 5;
        8'h36:
            dec = 6;
        8'h3D:
            dec = 7;
        8'h3E:
            dec = 8;
        8'h46:
            dec = 9;
        default:
            dec = 10;
            //Make function in display driver to turn off display
    endcase
end

endmodule