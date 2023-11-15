// Module written in lab
module VGA_display_driver(
    input pix_clk, 
    output hsync, vsync
    output [9:0] x_pos, y_pos
);

localparam HORIZONTAL_DISPLAY_PIXELS = 640;
localparam HSYNC_PULSE_WIDTH = 96;
localparam HSYNC_FRONT_PORCH = 16;
localparam HSYNC_BACK_PORCH = 48;
localparam HORIZONTAL_PIXELS = HORIZONTAL_DISPLAY_PIXELS + HSYNC_PULSE_WIDTH + HSYNC_BACK_PORCH + HSYNC_FRONT_PORCH; // = 800 pixels

localparam VERTICAL_DISPLAY_PIXELS = 480;
localparam VSYNC_PULSE_WIDTH = 2;
localparam VSYNC_FRONT_PORCH = 10;
localparam VSYNC_BACK_PORCH = 29; // Or 33?
localparam VERTICAL_PIXELS = VERTICAL_DISPLAY_PIXELS + VSYNC_PULSE_WIDTH + VSYNC_FRONT_PORCH + VSYNC_BACK_PORCH; // = 521, Or 525?

reg[9:0] row_pix, col_pix;

always @ (posedge pix_clk) begin
    // If scan operation is at the end of a row and needs to loop to next row
    if (row_pix == HORIZONTAL_PIXELS - 1 && col_pix < VERTICAL_PIXELS - 1) begin
        col_pix = col_pix + 1'b1;
        row_pix = 0;
    end
    // At the end of the frame, need to loop back to (0,0)
    else if ((row_pix == HORIZONTAL_PIXELS - 1) && (col_pix == VERTICAL_PIXELS - 1)) begin
        col_pix = 0;
        row_pix = 0;
    end
    // Else move to the next pixel
    else begin
        row_pix = row_pix + 1'b1;
    end
end

assign x_pos = row_pix;
assign y_pos = col_pix;
assign hsync = (row_pix < HSYNC_PULSE_WIDTH) || (row_pix == (HORIZONTAL_PIXELS - (HSYNC_BACK_PORCH - 1))) ? 0 : 1;
assign vsync = (col_pix < VSYNC_PULSE_WIDTH) || (col_pix == (VERTICAL_PIXELS - (VSYNC_BACK_PORCH - 1))) ? 0 : 1;
endmodule