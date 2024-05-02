default_nettype none // Sets the default net type to 'none' to catch errors like typo in variable names.

module textRow #( // Declares a module named 'textRow' with a parameter 'ADDRESS_OFFSET' defaulting to 8.
    parameter ADDRESS_OFFSET = 8'd0 // Defines the parameter 'ADDRESS_OFFSET'.
) (
    input clk, // Declares an input port named 'clk'.
    input [7:0] readAddress, // Declares an input bus named 'readAddress' of width 8 bits.
    output [7:0] outByte // Declares an output bus named 'outByte' of width 8 bits.
);
    reg [7:0] textBuffer [15:0]; // Declares a register array named 'textBuffer' with 16 elements of 8 bits each.
    integer i; // Declares an integer variable 'i'.

    initial begin // Begins initial block.
        for (i=0; i<15; i=i+1) begin // Iterates from 0 to 14.
            textBuffer[i] = 0; // Initializes each element of 'textBuffer' to 0.
        end
        textBuffer[0] = "H"; // Initializes textBuffer[0] to ASCII value of 'H'.
        textBuffer[1] = "e"; // Initializes textBuffer[1] to ASCII value of 'e'.
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

    assign outByte = textBuffer[(readAddress-ADDRESS_OFFSET)]; // Assigns 'outByte' to the element of 'textBuffer' based on 'readAddress' with an offset.

endmodule // Ends the module definition for 'textRow'.

module textEngine ( // Declares a module named 'textEngine'.
    input clk, // Declares an input port named 'clk'.
    input [9:0] pixelAddress, // Declares an input bus named 'pixelAddress' of width 10 bits.
    output [7:0] pixelData // Declares an output bus named 'pixelData' of width 8 bits.
);
    reg [7:0] fontBuffer [1519:0]; // Declares a register array named 'fontBuffer' with 1520 elements of 8 bits each.
    initial $readmemh("font.hex", fontBuffer); // Initializes 'fontBuffer' by reading from a memory file "font.hex".

    // Declares wires for address and row selection.
    wire [5:0] charAddress;
    wire [2:0] columnAddress;
    wire topRow;

    reg [7:0] outputBuffer; // Declares a register 'outputBuffer' of width 8 bits.

    // Declares wires for character output.
    wire [7:0] charOutput, chosenChar;
    wire [7:0] charOutput1, charOutput2, charOutput3, charOutput4;

    // Instantiates four instances of 'textRow' module with different address offsets.
    textRow #(6'd0) t1(
        clk,
        charAddress,
        charOutput1
    );
    textRow #(6'd16) t2(
        clk,
        charAddress,
        charOutput2
    );
    textRow #(6'd32) t3(
        clk,
        charAddress,
        charOutput3
    );
    textRow #(6'd48) t4(
        clk,
        charAddress,
        charOutput4
    );

    always @(posedge clk) begin // Executes the following block on positive edge of 'clk'.
        // Computes the output buffer based on selected character, column address, and row.
        outputBuffer <= fontBuffer[((chosenChar-8'd32) << 4) + (columnAddress << 1) + (topRow ? 0 : 1)];
    end

    // Assigns values to character address, column address, and row based on 'pixelAddress'.
    assign charAddress = {pixelAddress[9:8],pixelAddress[6:3]};
    assign columnAddress = pixelAddress[2:0];
    assign topRow = !pixelAddress[7];

    // Selects character output based on address and assigns it to 'charOutput'.
    assign charOutput = (charAddress[5] && charAddress[4]) ? charOutput4 : ((charAddress[5]) ? charOutput3 : ((charAddress[4]) ? charOutput2 : charOutput1));    
    // Chooses a valid ASCII character between 32 and 126, assigns to 'chosenChar'.
    assign chosenChar = (charOutput >= 32 && charOutput <= 126) ? charOutput : 32;
    
    // Assigns 'pixelData' with 'outputBuffer'.
    assign pixelData = outputBuffer;
endmodule // Ends the module definition for 'textEngine'.
