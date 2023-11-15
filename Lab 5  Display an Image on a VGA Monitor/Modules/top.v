// Instantiates all of the necessary modules, displays the image on the
// monitor, and handles the filtering action
module top(
    input clk, rst, PS2clk, key_data,
    output hsync, vsync,
    output reg [3:0] VGAR, VGAG, VGAB
);

wire [23:0] douta;
wire[10:0] x_pos, y_pos;
reg[18:0] kb_state;
reg[17:0] scan_state;
reg[3:0] filter_state, dec;
reg[16:0] RAM_state;
reg display_state, write_char, web2, web1;
wire video_on, kb_pressed, scan_start, scan_end, filter_end;
reg[15:0] addra1, addrb1, addra2, addrb2;
reg[7:0] dina1, dina2, dinb1, dinb2;
wire[7:0] c_data, douta1, douta2, doutb1, doutb2;
reg[7:0] pixels[8:0]; //2-dimensional reg of width 8 and height 9
reg[9:0] filtered_pixel;

// Instance of block ram to store the character data
blk_mem_gen_0 RAM1 (
    .douta(douta1),
    .doutb(doutb1),
    .addra(addra1),
    .addrb(addrb1),
    .dina(dina1),
    .dinb(dinb1),
    .web(web1),
    .clka(clk),
    .clkb(clk)
);

// Instance of block ram to store the character data
blk_mem_gen_0 RAM2 (
    .douta(douta2),
    .doutb(doutb2),
    .addra(addra2),
    .addrb(addrb2),
    .dina(dina2),
    .dinb(dinb2),
    .web(web2),
    .clka(clk),
    .clkb(clk)
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

// Keyboard state machine
always @ (posedge clk) begin
    case(kb_state)
        0: begin
            if (kb_pressed)
                kb_state <= kb_state + 1;
        end
        1: kb_state <= kb_state + 1;
        2: begin
            if (scan_end)
                kb_state <= kb_state + 1;
        end
        1000000: kb_state <= 0; //Needs to be a large number to allow the RAM state machine to finish its operation
        default: kb_state <= kb_state + 1;
    endcase
end

// Scan State machine
always @ (posedge clk) begin
    // Take the last two bits (4 states/pixel)
    case (scan_state[1:0])
        0: begin
            if (scan_start || scan_state > 3)
                scan_state <= scan_state + 1;
        end
        1: scan_state <= scan_state + 1;
        2: begin
            if (filter_end)
                scan_state <= scan_state + 1;
        end
        3: scan_state <= scan_state + 1;
        default: scan_state <= scan_state + 1;
    endcase
end

// Filter state machine and display state machine
always @ (posedge clk) begin
    case (filter_state)
        0: begin
            if(filter_start)
            filter_state <= filter_state + 1;
        end
        1: begin
            addra1 <= scan_state[17:2] - 257;
            filter_state <= filter_state + 1;
        end
        2: begin
            addra1 <= addra1 + 1;
            pixels[0] <= douta1;
            filter_state <= filter_state + 1;
        end
        3: begin
            addra1 <= addra1 + 1;
            pixels[1] <= douta1;
            filter_state <= filter_state + 1;
        end
        4: begin
            addra1 <= addra1 + 254; // 3rd pixel in the filter row, move to the next row
            pixels[2] <= douta1;
            filter_state <= filter_state + 1;
        end
        5: begin
            addra1 <= addra1 + 1;
            pixels[3] <= douta1;
            filter_state <= filter_state + 1;
        end
        6: begin
            addra1 <= addra1 + 1;
            pixels[4] <= douta1;
            filter_state <= filter_state + 1;
        end
        7: begin
            addra1 <= addra1 + 254; // 3rd pixel in the filter row, move to the next row
            pixels[5] <= douta1;
            filter_state <= filter_state + 1;
        end
        8: begin
            addra1 <= addra1 + 1;
            pixels[6] <= douta1;
            filter_state <= filter_state + 1;
        end
        9: begin
            addra1 <= addra1 + 1;
            pixels[7] <= douta1;
            filter_state <= filter_state + 1;
        end
        10: begin
            addra1 <= addra1 - 257; // Last filtered pixel, reset to top left
            pixels[8] <= douta1;
            filter_state <= filter_state + 1;
        end
        11: begin
            // Shift operation instead of division operation
            // 7/2^9 ~= 0.109 -> 1/9 = 0.111...
            filtered_pixel <= ((pixels[0] + pixels[1] + pixels[2] +
            pixels[3] + pixels[4] + pixels[5] + pixels[6] + pixels[7] +
            pixels[8]) * 7) >> 6;
            filter_state <= filter_state + 1;
        end
        12: begin
            addrb2 <= addra1; // addra1 indicates original pixel (top left of filter)
            filter_state <= filter_state + 1;
        end
        13: begin
            dinb2 <= filtered_pixel[7:0];
            web2 <= 1;
            filter_state <= filter_state + 1;
        end
        14: begin
            web2 <= 0;
            filter_state <= filter_state + 1;
        end
        15: begin
            filter_state <= 0;
        end
        default: begin
            filter_state <= filter_state + 1;
        end
    endcase

    // Are either starting scanning or have finished scanning
    if (scan_state == 0) begin
    case(display_state)
    0: begin
    addra1 <= x_pos * 256 + y_pos;
    display_state <= display_state + 1;
    end
    1: begin
    // If within bounds of the image (256 x 256), display the image pixels
    if (x_pos > 0 && x_pos < 256 && y_pos > 0 && y_pos < 256)
    begin
    VGAR <= douta1[7:4];
    VGAG <= douta1[7:4];
    VGAB <= douta1[7:4];
    end
    // If outside of region, display black
    else begin
    VGAR <= 0;
    VGAG <= 0;
    VGAB <= 0;
    end
    display_state <= display_state + 1;
    end
    endcase
    end
end

// RAM state machine
always @ (posedge clk) begin
    case (RAM_state)
        0: begin
            // On end of scan, begin incrementing RAM_state and initialize both addresses to 0
            if (scan_end) begin
                RAM_state <= RAM_state + 1;
                addrb1 <= 0;
                addra2 <= 0;
            end
        end
        // Write filtered image from RAM2 to RAM1
        1: begin
            web1 <= 1;
            dinb1 <= douta2;
            RAM_state <= RAM_state + 1;
        end
        // Repeat operation for 65536 cycles
        65538: begin
            web1 <= 0;
            RAM_state <= 0;
        end
        // Default state is increment addresses and copy from RAM2 to RAM1
        default: begin
            addrb1 <= addrb1 + 1;
            addra2 <= addra2 + 1;
            dinb1 <= douta2;
            RAM_state <= RAM_state + 1;
        end
    endcase
end

// Assign statements
assign kb_pressed = (c_data == 8'h45) ? 1:0;
assign scan_start = (kb_state == 1) ? 1:0;
assign filter_start = (scan_state[1:0] == 1) ? 1:0;
assign filter_end = (filter_state == 15) ? 1:0;
assign scan_end = (scan_state == 262143) ? 1:0;

endmodule