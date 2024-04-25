// In this code, we've replaced the 6-bit LFSR with a 16-bit LFSR. 
// The LFSR generates a new pseudo-random number at each 0.5s interval. 
// The lower 6 bits of the new value are then used to calculate a number between 0 and 5 using the modulo operation. 
// The result is then used to select which LED to light up. 
// The LEDs are represented as a 6-bit binary number, where each bit corresponds to an LED. 
// The << operator is used to shift the bit that represents the lit LED.

module led (
    input sys_clk,          // clk input
    input sys_rst_n,        // reset input
    output reg [5:0] led    // 6 LEDS pin
);

reg [23:0] counter;
reg [15:0] lfsr = 16'b0000_0000_0000_0001; // Initialize 16-bit LFSR

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        counter <= 24'd0;
    else if (counter < 24'd1349_9999)       // 0.5s delay
        counter <= counter + 1'b1;
    else
        counter <= 24'd0;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        led <= 6'b111110;
        lfsr <= 16'b0000_0000_0000_0001;
    end
    else if (counter == 24'd1349_9999) begin       // 0.5s delay
        // Update LFSR
        lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
        // Map lfsr to a number between 0 and 5 using modulo operation
        led <= 6'b000001 << (lfsr[2:0] % 6);
    end
    else
        led <= led;
end

endmodule