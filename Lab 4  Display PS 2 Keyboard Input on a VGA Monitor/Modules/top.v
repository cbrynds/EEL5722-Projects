// Instantiates all modules and handles displaying characters to the screen
module top(
    input clk, rst, PS2clk, key_data,
    output hsync, vsync,
    output reg [3:0] VGAR, VGAG, VGAB,
    output [3:0] an,
    output [6:0] seg
);

wire [23:0] douta;
reg[10:0] addra;
wire[10:0] x_pos, y_pos;
reg[3:0] dec;
wire[7:0] c_data;
wire video_on;
reg write_char;

// Instance of block ram to store the character data
character_block_mem inst (
    .douta(douta),
    .addra(addra),
    .clka(clk)
);

// Decodes the PS/2 signals
PS2_receiver receiver(
    .clk(clk),
    .PS2clk(PS2clk),
    .key_data(key_data),
    .c_data(c_data)
);

// Generates the signals to drive the VGA monitor
VGA_display_driver display_driver(
    .clk(clk),
    .hsync(hsync),
    .vsync(vsync),
    .p_tick(),
    .x_pos(x_pos),
    .y_pos(y_pos),
    .data_ena(video_on)
);
// Generates the signals to drive the seven-segment display
seven_segment_controller seg_ctrl(
    .clk(clk),
    .digit(dec),
    .an(an),
    .seg(seg)
);

// Only display character and read address in the top 8 x 16 pix corner of the screen
always @ (posedge clk) begin
    if (x_pos > 0 && x_pos < 8 && y_pos > 0 && y_pos < 16) begin
        addra <= (dec * 128) + (x_pos) + (y_pos) * 8;
        write_char <= 1'b1;
    end
    else
        write_char <= 1'b0;
    case (c_data)
        8'h45:
        dec = 4'b0000;
        8'h16:
        dec = 4'b0001;
        8'h1E:
        dec = 4'b0010;
        8'h26:
        dec = 4'b0011;
        8'h25:
        dec = 4'b0100;
        8'h2E:
        dec = 4'b0101;
        8'h36:
        dec = 4'b0110;
        8'h3D:
        dec = 4'b0111;
        8'h3E:
        dec = 4'b1000;
        8'h46:
        dec = 4'b1001;
        8'h5A:
        dec = 4'b1011;
        default:
        dec = 4'b1010;
    endcase
end

always @ (posedge clk) begin
    // On reset, if the video is off, or if a character is not being written, screen is black
    if (rst || ~video_on || ~write_char) begin
        VGAR = 0;
        VGAG = 0;
        VGAB = 0;
    end
    // Else display color data from block RAM
    else begin
        // Taking the 4 MSB of douta; can also do 4 LSB
        VGAR = douta[23:20];
        VGAG = douta[15:12];
        VGAB = douta[7:4];
    end
end
endmodule