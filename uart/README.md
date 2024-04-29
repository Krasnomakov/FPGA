![fontys_oled_tangNano.jpg](https://drive.google.com/uc?export=view&id=1Of7XyZnfqRW3BLoUy0Nbts_IfWVlpnaz)

The photo depicts TangNano9K communicating via UART protocol with a laptop. Each time a button is pressed bianries, hex and a message "Hello World" are sent. Lightning LEDs also change randomly each time a button is pressed.

uart_explained.v has explicitly commented Verilog

**Summary** 

1. **Module Declaration and Parameters**:
   - The Verilog module named `uart` is defined. It takes in several parameters, including `DELAY_FRAMES`, which determines the baud rate.
   
2. **Input and Output Ports**:
   - The module has input ports `clk`, `uart_rx`, and `btn1`, and an output port `uart_tx`. It also outputs to `led`.

3. **Initialization and Constants**:
   - Registers for the receiving process (`rxState`, `rxCounter`, `dataIn`, `rxBitNumber`, and `byteReady`) are initialized, along with constants defining different states of the receive process.
   
4. **Receive State Machine**:
   - The `always @(posedge clk)` block defines the behavior of the receive state machine.
   - It transitions between different states (`RX_STATE_IDLE`, `RX_STATE_START_BIT`, etc.) based on the received UART data and timing.
   - When a byte is fully received, `byteReady` is set to indicate that data is ready to be processed.
   
5. **LED Control**:
   - LEDs are controlled based on the received byte. When `byteReady` is set, the lower 6 bits of `dataIn` are inverted and assigned to `led`.
   
6. **Initialization and Constants for Transmission**:
   - Registers for the transmission process (`txState`, `txCounter`, `dataOut`, `txPinRegister`, `txBitNumber`, and `txByteCounter`) are initialized, along with constants defining different states of the transmit process.
   - A test message is stored in memory.
   
7. **Transmit State Machine**:
   - Similar to the receive state machine, the transmit state machine defines the behavior of transmitting data.
   - It cycles through different states (`TX_STATE_IDLE`, `TX_STATE_START_BIT`, etc.) to transmit each byte of the test message.
   - Debouncing is implemented to ensure proper button press detection.

8. **Output Assignment**:
   - Finally, `uart_tx` is assigned based on the value of `txPinRegister`, which controls the UART transmission pin.
