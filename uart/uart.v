//this Verilog makes LEDs blink when a sequences ABC is received 
//It uses a state machine to check for the sequence and set the LEDs

`default_nettype none

module uart
#(
    parameter DELAY_FRAMES = 234 // 27,000,000 (27Mhz) / 115200 Baud rate
)
(
    input clk,
    input uart_rx,
    output uart_tx,
    output reg [5:0] led,
    input btn1
);

localparam HALF_DELAY_WAIT = (DELAY_FRAMES / 2);

reg [3:0] rxState = 0;
reg [12:0] rxCounter = 0;
reg [7:0] dataIn = 0;
reg [2:0] rxBitNumber = 0;
reg byteReady = 0;

reg [31:0] blink_counter = 0; // Counter to control blinking rate
reg blink_state = 0; // State of blinking (on/off)
reg [5:0] led_temp = 0; // Temporary storage for LED values

localparam RX_STATE_IDLE = 0;
localparam RX_STATE_START_BIT = 1;
localparam RX_STATE_READ_WAIT = 2;
localparam RX_STATE_READ = 3;
localparam RX_STATE_STOP_BIT = 5;

reg [2:0] sequence_state = 0;
localparam SEQ_IDLE = 0;
localparam SEQ_A = 1;
localparam SEQ_B = 2;
localparam SEQ_C = 3;

always @(posedge clk) begin
    case (rxState)
        RX_STATE_IDLE: begin
            if (uart_rx == 0) begin
                rxState <= RX_STATE_START_BIT;
                rxCounter <= 1;
                rxBitNumber <= 0;
                byteReady <= 0;
            end
        end 
        RX_STATE_START_BIT: begin
            if (rxCounter == HALF_DELAY_WAIT) begin
                rxState <= RX_STATE_READ_WAIT;
                rxCounter <= 1;
            end else 
                rxCounter <= rxCounter + 1;
        end
        RX_STATE_READ_WAIT: begin
            rxCounter <= rxCounter + 1;
            if ((rxCounter + 1) == DELAY_FRAMES) begin
                rxState <= RX_STATE_READ;
            end
        end
        RX_STATE_READ: begin
            rxCounter <= 1;
            dataIn <= {uart_rx, dataIn[7:1]};
            rxBitNumber <= rxBitNumber + 1;
            if (rxBitNumber == 3'b111)
                rxState <= RX_STATE_STOP_BIT;
            else
                rxState <= RX_STATE_READ_WAIT;
        end
        RX_STATE_STOP_BIT: begin
            rxCounter <= rxCounter + 1;
            if ((rxCounter + 1) == DELAY_FRAMES) begin
                rxState <= RX_STATE_IDLE;
                rxCounter <= 0;
                byteReady <= 1;
            end
        end
    endcase
end

// Check received data (need ABC) and set LED pattern 
always @(posedge clk) begin
    if (byteReady) begin
        case (sequence_state)
            SEQ_IDLE: begin
                if (dataIn == 8'h41) begin // 'A'
                    sequence_state <= SEQ_A;
                end
            end
            SEQ_A: begin
                if (dataIn == 8'h42) begin // 'B'
                    sequence_state <= SEQ_B;
                end else if (dataIn != 8'h41) begin
                    sequence_state <= SEQ_IDLE;
                end
            end
            SEQ_B: begin
                if (dataIn == 8'h43) begin // 'C'
                    sequence_state <= SEQ_C;
                end else if (dataIn != 8'h42) begin
                    sequence_state <= SEQ_IDLE;
                end
            end
            SEQ_C: begin
                // Sequence 'ABC' is complete, set LED pattern
                led_temp <= 6'b111111; // Example pattern, set all LEDs
                sequence_state <= SEQ_IDLE; // Reset state
            end
        endcase
    end else begin
        led_temp <= 0; // Turn off LEDs
    end
end

// Blinking logic
always @(posedge clk) begin
    if (led_temp != 0) begin
        blink_counter <= blink_counter + 1;
        if (blink_counter >= 1000000) begin // Adjust this value based on your clock for desired blink rate
            blink_counter <= 0;
            blink_state <= ~blink_state;
        end
        led <= (blink_state ? led_temp : 0); // Toggle LEDs based on blink_state
    end else begin
        led <= 0; // Ensure LEDs are off when not required to blink
        blink_counter <= 0; // Reset counter
    end
end

reg [3:0] txState = 0;
reg [24:0] txCounter = 0;
reg [7:0] dataOut = 0;
reg txPinRegister = 1;
reg [2:0] txBitNumber = 0;
reg [3:0] txByteCounter = 0;

assign uart_tx = txPinRegister;

localparam MEMORY_LENGTH = 12;
reg [7:0] testMemory [MEMORY_LENGTH-1:0];

initial begin
    testMemory[0] = "H";
    testMemory[1] = "e";
    testMemory[2] = "l";
    testMemory[3] = "l";
    testMemory[4] = "o";
    testMemory[5] = " ";
    testMemory[6] = "W";
    testMemory[7] = "o";
    testMemory[8] = "r";
    testMemory[9] = "l";
    testMemory[10] = "d";
    testMemory[11] = " ";
end

localparam TX_STATE_IDLE = 0;
localparam TX_STATE_START_BIT = 1;
localparam TX_STATE_WRITE = 2;
localparam TX_STATE_STOP_BIT = 3;
localparam TX_STATE_DEBOUNCE = 4;

always @(posedge clk) begin
    case (txState)
        TX_STATE_IDLE: begin
            if (btn1 == 0) begin
                txState <= TX_STATE_START_BIT;
                txCounter <= 0;
                txByteCounter <= 0;
            end
            else begin
                txPinRegister <= 1;
            end
        end 
        TX_STATE_START_BIT: begin
            txPinRegister <= 0;
            if ((txCounter + 1) == DELAY_FRAMES) begin
                txState <= TX_STATE_WRITE;
                dataOut <= testMemory[txByteCounter];
                txBitNumber <= 0;
                txCounter <= 0;
            end else 
                txCounter <= txCounter + 1;
        end
        TX_STATE_WRITE: begin
            txPinRegister <= dataOut[txBitNumber];
            if ((txCounter + 1) == DELAY_FRAMES) begin
                if (txBitNumber == 3'b111) begin
                    txState <= TX_STATE_STOP_BIT;
                end else begin
                    txState <= TX_STATE_WRITE;
                    txBitNumber <= txBitNumber + 1;
                end
                txCounter <= 0;
            end else 
                txCounter <= txCounter + 1;
        end
        TX_STATE_STOP_BIT: begin
            txPinRegister <= 1;
            if ((txCounter + 1) == DELAY_FRAMES) begin
                if (txByteCounter == MEMORY_LENGTH - 1) begin
                    txState <= TX_STATE_DEBOUNCE;
                end else begin
                    txByteCounter <= txByteCounter + 1;
                    txState <= TX_STATE_START_BIT;
                end
                txCounter <= 0;
            end else 
                txCounter <= txCounter + 1;
        end
        TX_STATE_DEBOUNCE: begin
            if (txCounter == 23'b111111111111111111) begin
                if (btn1 == 1) 
                    txState <= TX_STATE_IDLE;
            end else
                txCounter <= txCounter + 1;
        end
    endcase      
end
endmodule
