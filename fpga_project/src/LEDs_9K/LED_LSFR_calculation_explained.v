// This module is used to control a set of LEDs using a 16-bit Linear Feedback Shift Register (LFSR)

module led (
    input sys_clk,          // This is the system clock input. It's used to synchronize the operations of the module.
    input sys_rst_n,        // This is the reset input. When it's active (low), it resets the state of the module.
    output reg [5:0] led    // This is the output register for the 6 LEDs. Each bit corresponds to an LED.
);

// This is a 24-bit counter used to create a delay of 0.5 seconds.
reg [23:0] counter;

// This is a 16-bit LFSR used to generate pseudo-random numbers.
reg [15:0] lfsr = 16'b0000_0000_0000_0001; // Initialize 16-bit LFSR

// This block of code is executed on every rising edge of the system clock or on the falling edge of the reset signal.
always @(posedge sys_clk or negedge sys_rst_n) begin
    // If the reset signal is active (low), the counter is reset to 0.
    if (!sys_rst_n)
        counter <= 24'd0;
    // If the counter is less than 13499999 (which corresponds to a delay of 0.5 seconds), it's incremented by 1.
    else if (counter < 24'd1349_9999)       // 0.5s delay
        counter <= counter + 1'b1;
    // If the counter has reached 13499999, it's reset to 0.
    else
        counter <= 24'd0;
end

// This block of code is executed on every rising edge of the system clock or on the falling edge of the reset signal.
always @(posedge sys_clk or negedge sys_rst_n) begin
    // If the reset signal is active (low), the LFSR and the LED register are reset.
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