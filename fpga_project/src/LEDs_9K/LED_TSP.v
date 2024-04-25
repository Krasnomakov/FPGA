//The current implementation of the code doesn't include any logic for the salesman to choose the next city based on the shortest distance. 
// It simply cycles through the cities in the order they are defined in the cities array.

module TravellingSalesman(
    input wire sys_clk, // system clock
    input wire sys_rst_n, // system reset
    output reg [5:0] led
);
    // Coordinates of the cities
    reg [15:0] cities [0:5]; // Declare the array

    initial begin
        // Initialize the array
        cities[0] = 16'd1;
        cities[1] = 16'd2;
        cities[2] = 16'd3;
        cities[3] = 16'd4;
        cities[4] = 16'd5;
        cities[5] = 16'd6;
    end

    // Current city
    reg [2:0] current_city = 3'b000;

    // Counter for delay
    reg [31:0] counter = 32'd0;

    // Function to calculate the distance between two cities
    function [15:0] distance;
        input [15:0] city1, city2;
        begin
            distance = city2 - city1; // Simplified distance calculation for this example
        end
    endfunction

    // Always block to simulate the travelling salesman
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            current_city <= 3'b000;
            led <= 6'b000001;
            counter <= 32'd0;
        end else begin
            counter <= counter + 1'b1;
            if (counter == 32'd50000000) begin // Adjust this value to change the delay
                counter <= 32'd0;
                if (current_city == 6) begin
                    current_city <= 3'b000;
                    led <= 6'b000001;
                end else begin
                    // Visit the next city
                    current_city <= current_city + 1'b1;
                    led <= 1 << current_city;
                end
            end
        end
    end
endmodule