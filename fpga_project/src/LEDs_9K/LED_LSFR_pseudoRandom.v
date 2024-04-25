// In this code, we've added a 6-bit LFSR that generates a new pseudo-random number at each 0.5s interval. 
// The new value is then assigned to the led register. 
// The LFSR is initialized to 000001 because an LFSR cannot be initialized to 000000.

module led (
    input sys_clk,          // clk input
    input sys_rst_n,        // reset input
    output reg [5:0] led    // 6 LEDS pin
);

reg [23:0] counter;
reg [5:0] lfsr = 6'b000001; // Initialize LFSR

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        counter <= 24'd0;
    else if (counter < 24'd1349_9999)       // 0.5s delay
        counter <= counter + 1'b1;
    else
        counter <= 24'd0;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        led <= 6'b111110;
    else if (counter == 24'd1349_9999)       // 0.5s delay
    begin
        // Update LFSR
        lfsr <= {lfsr[4:0], lfsr[5] ^ lfsr[2]};
        led <= lfsr; // Assign LFSR value to led
    end
    else
        led <= led;
end

endmodule