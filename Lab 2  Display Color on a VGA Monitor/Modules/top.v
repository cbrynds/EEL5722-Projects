module top(
    input btn, rst, clk,
    output hsync, vsync,
    output reg [3:0] VGAR, VGAG, VGAB, 
    output [3:0] an,
    output [6:0] seg
);

wire [3:0] ones;
wire clk_4Hz, video_on;

VGA_display_driver display_driver(.clk(clk), .rst(rst), .hsync(hsync), .vsync(vsync), .p_tick(), .x_pos(), .y_pos(), .data_ena(video_on));
seven_segment_controller seg_ctrl(.clk(clk), .ones(ones), .an(an), .seg(seg));
BSM button_state_machine(.btn(btn), .clk_4Hz(clk_4Hz), .reset(rst), .ones(ones));
clk_4Hz clock_divider_4Hz(.clkIn(clk), .clkOut(clk_4Hz));

always @ (posedge clk) begin
    // On reset (or if video is off), screen is black
    if (rst || ~video_on) begin
        VGAR = 0;
        VGAG = 0;
        VGAB = 0;
    end
    // Set different color cases
    else begin 
        case (ones)
            // Red
            4'b0000: begin
                VGAR = 4'b1111;
                VGAG = 4'b0000;
                VGAB = 4'b0000;
            end
            // Green
            4'b0001: begin
                VGAR = 4'b0000;
                VGAG = 4'b1111;
                VGAB = 4'b0000;
            end
            // Blue
            4'b0010: begin
                VGAR = 4'b0000;
                VGAG = 4'b0000;
                VGAB = 4'b1111;
            end
            // Yellow
            4'b0011: begin
                VGAR = 4'b1111;
                VGAG = 4'b1100;
                VGAB = 4'b0000;
            end
            // Purple
            4'b0100: begin
                VGAR = 4'b1010;
                VGAG = 4'b0000;
                VGAB = 4'b1111;
            end
            // Pink
            4'b0101: begin
                VGAR = 4'b1111;
                VGAG = 4'b0011;
                VGAB = 4'b1010;
            end
            // Orange
            4'b0110: begin
                VGAR = 4'b1111;
                VGAG = 4'b0111;
                VGAB = 4'b0000;
            end
            // White
            4'b0111: begin
                VGAR = 4'b1111;
                VGAG = 4'b1111;
                VGAB = 4'b1111;
            end
            // White
            default: begin
                VGAR = 4'b1111;
                VGAG = 4'b1111;
                VGAB = 4'b1111;
            end
        endcase
    end
end

endmodule