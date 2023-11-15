`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2023 12:38:20 PM
// Design Name: 
// Module Name: SevenSegDisplay
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


module seven_segment_display(
    input clk_100Hz,
    output reg [3:0] an
    );
    reg state;
    
    initial begin
        state = 1'b0;
    end
    
    always @ (posedge clk_100Hz) begin
        case (state)
            1'b0: begin
                an <= 4'b1110; // Must be non-blocking to ensure state change occurs on next clock edge
                state <= 1'b1; // Ensures that code states at state 0 for a full clock cycle
            end
            1'b1: begin
                an <= 4'b1101;
                state <= 1'b0;
            end
            default: begin
                an <= 4'b1110;
                state <= 1'b1;
            end
        endcase
    end
    

endmodule
