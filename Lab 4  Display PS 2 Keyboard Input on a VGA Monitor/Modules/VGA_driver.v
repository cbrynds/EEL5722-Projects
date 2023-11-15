module VGA_display_driver(
    input clk, rst,
    output hsync, vsync, data_ena, p_tick,
    output [9:0] x_pos, y_pos
);

// Horizontal Dimensions
localparam HORIZONTAL_DISPLAY_PIXELS = 640; // Horizontal display area
localparam HSYNC_PULSE_WIDTH = 96; // Horizontal pulse width for retrace
localparam HSYNC_FRONT_PORCH = 16; // Horizontal left border
localparam HSYNC_BACK_PORCH = 48; // Horizontal right border
localparam HORIZONTAL_PIXELS = HORIZONTAL_DISPLAY_PIXELS + HSYNC_PULSE_WIDTH +
HSYNC_BACK_PORCH + HSYNC_FRONT_PORCH - 1; // = 800 pixels

// Horizontal Timings
localparam H_RETRACE_START = HORIZONTAL_DISPLAY_PIXELS + HSYNC_FRONT_PORCH - 1;
localparam H_RETRACE_END = H_RETRACE_START + HSYNC_PULSE_WIDTH;

// Vertical Dimensions
localparam VERTICAL_DISPLAY_PIXELS = 480; // Vertical display area
localparam VSYNC_PULSE_WIDTH = 2; // Vertical pulse width for retrace
localparam VSYNC_FRONT_PORCH = 10; // Vertical top border
localparam VSYNC_BACK_PORCH = 29; // Vertical bottom border
localparam VERTICAL_PIXELS = VERTICAL_DISPLAY_PIXELS + VSYNC_PULSE_WIDTH +
VSYNC_FRONT_PORCH + VSYNC_BACK_PORCH - 1; // = 521 pixels

// Vertical Timings
localparam V_RETRACE_START = VERTICAL_DISPLAY_PIXELS + VSYNC_FRONT_PORCH - 1;
localparam V_RETRACE_END = V_RETRACE_START + VSYNC_PULSE_WIDTH;

reg [1:0] pixel_reg;
wire [1:0] pixel_next;
wire pixel_tick;

always @ (posedge clk) begin
    if (rst)
        pixel_reg <= 0;
    else
        pixel_reg <= pixel_next;
end

assign pixel_next = pixel_reg + 1;
assign pixel_tick = (pixel_reg == 0); // Divide 100MHz clock 4x down to 25MHz
reg vsync_reg, hsync_reg;
wire vsync_next, hsync_next;
reg[9:0] row_pix, next_row_pix, col_pix, next_col_pix;

// Sequential Logic
always @ (posedge clk) begin
    if (rst) begin
        row_pix <= 0;
        col_pix <= 0;
        vsync_reg <= 0;
        hsync_reg <= 0;
    end
    else begin
        row_pix <= next_row_pix;
        col_pix <= next_col_pix;
        vsync_reg <= vsync_next;
        hsync_reg <= hsync_next;
    end
end

// Combinational Logic
always @ (*) begin
    if (pixel_tick) begin
        if (row_pix == HORIZONTAL_PIXELS)
            next_row_pix = 0;
        else
            next_row_pix = row_pix + 1;
    end
    else
        next_row_pix = row_pix;
    if (pixel_tick && row_pix == HORIZONTAL_PIXELS) begin
        if (col_pix == VERTICAL_PIXELS)
            next_col_pix = 0;
        else
            next_col_pix = col_pix + 1;
    end
    else
        next_col_pix = col_pix;
end

assign hsync_next = (row_pix >= H_RETRACE_START && row_pix <= H_RETRACE_END);
assign vsync_next = (col_pix >= V_RETRACE_START && col_pix <= V_RETRACE_END);
assign data_ena = (row_pix < HORIZONTAL_DISPLAY_PIXELS && col_pix < VERTICAL_DISPLAY_PIXELS);
assign hsync = hsync_reg;
assign vsync = vsync_reg;
assign x_pos = row_pix;
assign y_pos = col_pix;
assign p_tick = pixel_tick;

endmodule