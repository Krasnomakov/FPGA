// In this code, we've added a state register that increments every time the counter resets. 
// This state register is used in a case statement to select the LED pattern. 
// The sequence is 1 - 4 - 2 - 5 - 0 - 2, after which it goes back to the default state.

module led (
    input sys_clk,          // clk input
    input sys_rst_n,        // reset input
    output reg [5:0] led    // 6 LEDS pin
);

reg [23:0] counter;
reg [2:0] state;

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
        state <= 3'b000;
    end
    else if (counter == 24'd1349_9999) begin       // 0.5s delay
        case (state)
            3'b000: led <= 6'b000001; // LED 1
            3'b001: led <= 6'b000100; // LED 4
            3'b010: led <= 6'b000010; // LED 2
            3'b011: led <= 6'b001000; // LED 5
            3'b100: led <= 6'b000000; // LED 0
            3'b101: led <= 6'b000010; // LED 2
            default: led <= 6'b111110;
        endcase
        state <= state + 1'b1;
    end
    else
        led <= led;
end

endmodule