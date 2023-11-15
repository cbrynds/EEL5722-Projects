module clk_100Hz(
    input clkIn,
    output reg clkOut
    );
    
    reg[19:0] N; // Value to divide clock, calculated by fout = fin/(2*N) 
    always @ (posedge clkIn) begin
        if (N == 500000) begin
            clkOut <= ~clkOut;
            N <= 19'b0;
        end
        else 
            N= N + 1'b1;
    end
endmodule