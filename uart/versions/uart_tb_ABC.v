`default_nettype none

module test();
  reg clk = 0;
  reg uart_rx = 1;
  wire uart_tx;
  wire [5:0] led;
  reg btn1 = 1;

  uart #(8'd234) u(
    .clk(clk),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    .led(led),
    .btn1(btn1)
  );

  always
    #1  clk = ~clk;

  initial begin
    $display("Starting UART RX");
    $monitor("LED Value %b", led);
    
    // Send 'A' (0x41)
    #10 uart_rx = 0; // Start bit
    #16 uart_rx = 1;
    #16 uart_rx = 0;
    #16 uart_rx = 0;
    #16 uart_rx = 0;
    #16 uart_rx = 0;
    #16 uart_rx = 1;
    #16 uart_rx = 0;
    #16 uart_rx = 0;
    #16 uart_rx = 1; // Stop bit
    
    // Send 'B' (0x42)
    #16 uart_rx = 0; // Start bit
    #16 uart_rx = 1;
    #16 uart_rx = 0;
    #16 uart_rx = 0;
    #16 uart_rx = 0;
    #16 uart_rx = 1;
    #16 uart_rx = 0;
    #16 uart_rx = 1;
    #16 uart_rx = 0;
    #16 uart_rx = 1; // Stop bit
    
    // Send 'C' (0x43)
    #16 uart_rx = 0; // Start bit
    #16 uart_rx = 1;
    #16 uart_rx = 0;
    #16 uart_rx = 0;
    #16 uart_rx = 0;
    #16 uart_rx = 1;
    #16 uart_rx = 0;
    #16 uart_rx = 1;
    #16 uart_rx = 1;
    #16 uart_rx = 1; // Stop bit
    
    #1000 $finish;
  end

  initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, test);
    $dumpvars(1, clk, uart_rx, led, u.byteReady, u.dataIn, u.rxState, u.sequence_state, u.led_temp);
  end
endmodule
