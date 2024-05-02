module textRow #(
    parameter ADDRESS_OFFSET = 8'd0,
    parameter DELAY_VALUE = 16'd50000 // Adjust this value for desired delay
) (
    input clk,
    input [7:0] readAddress,
    output [7:0] outByte
);
    reg [7:0] textBuffer [15:0];
    integer i;
    reg [31:0] delay_counter; // Counter for introducing delay
    reg [3:0] char_index; // Index to control character display

    initial begin
        delay_counter = 0;
        char_index = 0;
        
        for (i=0; i<15; i=i+1) begin
            textBuffer[i] = 0;
        end
        textBuffer[0] = "H";
        textBuffer[1] = "e";
        textBuffer[2] = "l";
        textBuffer[3] = "l";
        textBuffer[4] = "o";
        textBuffer[5] = " ";
        textBuffer[6] = "W";
        textBuffer[7] = "o";
        textBuffer[8] = "r";
        textBuffer[9] = "l";
        textBuffer[10] = "d";
        textBuffer[11] = "!";
    end

    always @(posedge clk) begin
        // Increment delay counter
        if (delay_counter < DELAY_VALUE)
            delay_counter <= delay_counter + 1;
        else begin
            delay_counter <= 0;
            // Display next character
            if (char_index < 12) // Adjust the condition based on the number of characters
                char_index <= char_index + 1;
        end
    end

    assign outByte = (delay_counter == DELAY_VALUE && char_index < 12) ? textBuffer[char_index] : 0; // Output the character when delay_counter reaches DELAY_VALUE

endmodule
