`timescale 1ns / 1ps

module BSM(
    input btn, reset, clk_4Hz,
    output reg [3:0] ones
);

always @ (posedge clk_4Hz) begin
    if (reset)
        ones <= 0;
    else begin
        if (btn)
            ones <= (ones + 1'b1) % 8;
        else
            ones <= ones;
    end
end

endmodule