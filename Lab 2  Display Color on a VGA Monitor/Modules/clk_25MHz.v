module clk_25MHz(
    input clkIn,
    output reg clkOut
    );
    
    reg[1:0] N; // Value to divide clock, calculated by fout = fin/(2*N) 
    always @ (posedge clkIn) begin
        if (N == 2) begin
            clkOut <= ~clkOut;
            N <= 2'b0;
        end
        else 
            N= N + 1'b1;
    end
endmodule