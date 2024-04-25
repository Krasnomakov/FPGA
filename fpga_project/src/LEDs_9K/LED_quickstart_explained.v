// Verilog code explained for LED quick start  

// This Verilog code defines a module named "led" that uses a counter to create a delay and then shifts the bits of the "led" register. 
// The counter is incremented at every positive edge of the system clock until it reaches a certain value (13499999), which corresponds to a delay of 0.5 seconds. 
// When the counter reaches this value, the bits of the "led" register are shifted to the right by 1 bit. 
// The system reset signal is used to reset the counter and the "led" register to their initial values. 

module led ( // Define a module named "led"
    input sys_clk,          // Declare an input signal named "sys_clk" which is the system clock
    input sys_rst_n,        // Declare an input signal named "sys_rst_n" which is the system reset signal
    output reg [5:0] led    // Declare an output register array named "led" with 6 bits
);

reg [23:0] counter; // Declare a register array named "counter" with 24 bits

// This block of code is always executed at the positive edge of the system clock or the negative edge of the system reset signal
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) // If the system reset signal is not active (active low)
        counter <= 24'd0; // Reset the counter to 0
    else if (counter < 24'd1349_9999)       // If the counter is less than 13499999 (0.5s delay)
        counter <= counter + 1'b1; // Increment the counter by 1
    else // If none of the above conditions are met
        counter <= 24'd0; // Reset the counter to 0
end

// This block of code is always executed at the positive edge of the system clock or the negative edge of the system reset signal
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) // If the system reset signal is not active (active low)
        led <= 6'b111110; // Set the led register to 111110
    else if (counter == 24'd1349_9999)       // If the counter is equal to 13499999 (0.5s delay)
        led[5:0] <= {led[4:0],led[5]}; // Shift the led register to the right by 1 bit
    else // If none of the above conditions are met
        led <= led; // Keep the led register as it is
end

endmodule // End of the module