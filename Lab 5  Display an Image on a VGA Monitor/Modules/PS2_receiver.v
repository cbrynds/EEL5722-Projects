// Reads the bitstream from the USB keyboard and decodes the corresponding scancode
module PS2_receiver(
    input clk, PS2clk, key_data,
    output reg [7:0] c_data
);

reg [10:0] store;
reg [7:0] current_c_data;
reg [3:0] count;
reg [1:0] signal_high_counter;
wire parity_check;
reg [7:0] c_data_buffer;

// Store sets of 10 bits into the 'store' register
always @ (negedge PS2clk) begin
    if (count < 10) begin
        store[count] <= key_data;
        count <= count + 1;
    end
    else begin
        count <= 0;
    end
end

// Check for parity bit to signal the end of a PS/2 signal
assign parity_check = ~((store[1] ^
store[8])^(store[2]^store[3])^(store[4]^store[5])^(store[6]^store[7]));

// If a valid command has been issued, store scancode in c_data
always @ (posedge clk) begin
    // If the start of a command has been issued
    if (store[0] == 0 && parity_check == store[9]) begin
        c_data_buffer <= store[8:1];
        if (c_data_buffer == store[8:1])
            c_data <= 0;
        else
            c_data <= store[8:1];
    end
end

endmodule