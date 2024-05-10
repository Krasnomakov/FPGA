//in this script it is possible to send data to PC when button is pressed (sends the message to serial console)
//and receive data from PC and display it on the LEDs (receive digits or letters and convert their binary representation to decimal and display it on the LEDs)
//use the most significant 6 bits of the received data to display on the LEDs

`default_nettype none  // Set default net type to none to prevent unintentional net declarations

module uart // Define a Verilog module named uart
#(
    parameter DELAY_FRAMES = 234 // 27,000,000 (27Mhz) / 115200 Baud rate
)
(
    input clk,          // Clock input
    input uart_rx,      // UART receive input
    output uart_tx,     // UART transmit output
    output reg [5:0] led, // Output for LEDs
    input btn1          // Input button
);

localparam HALF_DELAY_WAIT = (DELAY_FRAMES / 2); // Define a local parameter for half of DELAY_FRAMES

// Registers for receiving data
reg [3:0] rxState = 0;         // State of receive process
reg [12:0] rxCounter = 0;      // Counter for receive timing
reg [7:0] dataIn = 0;          // Received data
reg [2:0] rxBitNumber = 0;     // Bit number being received
reg byteReady = 0;             // Flag indicating received byte is ready


// Constants defining receive states
localparam RX_STATE_IDLE = 0;            // Idle state
localparam RX_STATE_START_BIT = 1;       // State for detecting start bit
localparam RX_STATE_READ_WAIT = 2;       // State for waiting to read data
localparam RX_STATE_READ = 3;            // State for reading data
localparam RX_STATE_STOP_BIT = 5;        // State for detecting stop bit

// State machine for receiving data
always @(posedge clk) begin
    case (rxState) // Case statement based on rxState
        RX_STATE_IDLE: begin // If in IDLE state
            if (uart_rx == 0) begin // If UART receive line is low
                rxState <= RX_STATE_START_BIT; // Move to START_BIT state
                rxCounter <= 1; // Initialize counter
                rxBitNumber <= 0; // Initialize bit number
                byteReady <= 0; // Clear byte ready flag
            end
        end 
        RX_STATE_START_BIT: begin // If in START_BIT state
            if (rxCounter == HALF_DELAY_WAIT) begin // If half delay has passed
                rxState <= RX_STATE_READ_WAIT; // Move to READ_WAIT state
                rxCounter <= 1; // Reset counter
            end else 
                rxCounter <= rxCounter + 1; // Increment counter
        end
        RX_STATE_READ_WAIT: begin // If in READ_WAIT state
            rxCounter <= rxCounter + 1; // Increment counter
            if ((rxCounter + 1) == DELAY_FRAMES) begin // If delay frames reached
                rxState <= RX_STATE_READ; // Move to READ state
            end
        end
        RX_STATE_READ: begin // If in READ state
            rxCounter <= 1; // Reset counter
            dataIn <= {uart_rx, dataIn[7:1]}; // Shift received bit into dataIn register
            rxBitNumber <= rxBitNumber + 1; // Increment bit number
            if (rxBitNumber == 3'b111) // If all bits received
                rxState <= RX_STATE_STOP_BIT; // Move to STOP_BIT state
            else
                rxState <= RX_STATE_READ_WAIT; // Otherwise, continue waiting for next bit
        end
        RX_STATE_STOP_BIT: begin // If in STOP_BIT state
            rxCounter <= rxCounter + 1; // Increment counter
            if ((rxCounter + 1) == DELAY_FRAMES) begin // If delay frames reached
                rxState <= RX_STATE_IDLE; // Move back to IDLE state
                rxCounter <= 0; // Reset counter
                byteReady <= 1; // Set byte ready flag
            end
        end
    endcase
end

// LED control based on received byte
always @(posedge clk) begin
    if (byteReady) begin // If byte ready flag is set
        led <= ~dataIn[5:0]; // Invert and assign lower 6 bits of received data to LEDs, if invert is removed, the LEDs will display the received data as is
    end
end

// Registers for transmitting data
reg [3:0] txState = 0;          // State of transmit process
reg [24:0] txCounter = 0;       // Counter for transmit timing
reg [7:0] dataOut = 0;          // Data to be transmitted
reg txPinRegister = 1;          // Pin register for UART transmit
reg [2:0] txBitNumber = 0;      // Bit number being transmitted
reg [3:0] txByteCounter = 0;    // Counter for transmitted bytes

// Test message stored in memory
localparam MEMORY_LENGTH = 12; // Length of test message memory
reg [7:0] testMemory [MEMORY_LENGTH-1:0]; // Array to store test message

initial begin // Initialization block
    testMemory[0] = "L"; // Load test message into memory
    testMemory[1] = "u";
    testMemory[2] = "s";
    testMemory[3] = "h";
    testMemory[4] = "a";
    testMemory[5] = "y";
    testMemory[6] = " ";
    testMemory[7] = "L";
    testMemory[8] = "a";
    testMemory[9] = "b";
    testMemory[10] = "s";
    testMemory[11] = " ";
end

// Constants defining transmit states
localparam TX_STATE_IDLE = 0;            // Idle state
localparam TX_STATE_START_BIT = 1;       // State for transmitting start bit
localparam TX_STATE_WRITE = 2;           // State for transmitting data
localparam TX_STATE_STOP_BIT = 3;        // State for transmitting stop bit
localparam TX_STATE_DEBOUNCE = 4;        // State for debouncing button

// State machine for transmitting data
always @(posedge clk) begin
    case (txState) // Case statement based on txState
        TX_STATE_IDLE: begin // If in IDLE state
            if (btn1 == 0) begin // If button is pressed
                txState <= TX_STATE_START_BIT; // Move to START_BIT state
                txCounter <= 0; // Initialize counter
                txByteCounter <= 0; // Initialize byte counter
            end
            else begin
                txPinRegister <= 1; // If button not pressed, keep pin high
            end
        end 
        TX_STATE_START_BIT: begin // If in START_BIT state
            txPinRegister <= 0; // Set pin low for start bit
            if ((txCounter + 1) == DELAY_FRAMES) begin // If delay frames reached
                txState <= TX_STATE_WRITE; // Move to WRITE state
                dataOut <= testMemory[txByteCounter]; // Load next byte to be transmitted
                txBitNumber <= 0; // Reset bit number
                txCounter <= 0; // Reset counter
            end else 
                txCounter <= txCounter + 1; // Increment counter
        end
        TX_STATE_WRITE: begin // If in WRITE state
            txPinRegister <= dataOut[txBitNumber]; // Transmit data bit
            if ((txCounter + 1) == DELAY_FRAMES) begin // If delay frames reached
                if (txBitNumber == 3'b111) begin // If all bits transmitted
                    txState <= TX_STATE_STOP_BIT; // Move to STOP_BIT state
                end else begin
                    txState <= TX_STATE_WRITE; // Continue writing bits
                    txBitNumber <= txBitNumber + 1; // Move to next bit
                end
                txCounter <= 0; // Reset counter
            end else 
                txCounter <= txCounter + 1; // Increment counter
        end
        TX_STATE_STOP_BIT: begin // If in STOP_BIT state
            txPinRegister <= 1; // Set pin high for stop bit
            if ((txCounter + 1) == DELAY_FRAMES) begin // If delay frames reached
                if (txByteCounter == MEMORY_LENGTH - 1) begin // If all bytes transmitted
                    txState <= TX_STATE_DEBOUNCE; // Move to DEBOUNCE state
                end else begin
                    txByteCounter <= txByteCounter + 1; // Move to next byte
                    txState <= TX_STATE_START_BIT; // Start transmitting next byte
                end
                txCounter <= 0; // Reset counter
            end else 
                txCounter <= txCounter + 1; // Increment counter
        end
        TX_STATE_DEBOUNCE: begin // If in DEBOUNCE state
            if (txCounter == 23'b111111111111111111) begin // If debounce period elapsed
                if (btn1 == 1) 
                    txState <= TX_STATE_IDLE; // Return to IDLE state after debouncing
            end else
                txCounter <= txCounter + 1; // Increment counter
        end
    endcase      
end
endmodule // End of module
