#UART 

Original code and explained are in the folder "versions"

uart.v has logic to send and receive data via UART protocol 

When A, B or C are received it makes LEDs blink 

It is different from the initial UART code from lushay labs (uart_initial.v in versions). 
Original code uses static logic, while this one makes LEDs blink

Data Reception and LED Control: 
The code checks if a byte is ready for reading (byteReady). If the received data is 'A', 'B', or 'C' (represented in hexadecimal as '41', '42', '43'), it sets a temporary LED pattern (led_temp) to all ones, indicating that all LEDs should be turned on. If the received data is not 'A', 'B', or 'C', it turns off all LEDs by setting led_temp to zero.

LED Blinking Logic: 
This part of the code is triggered at every positive edge of the clock signal (clk). If led_temp is not zero (meaning some LEDs should be on), it increments a counter (blink_counter). When this counter reaches a certain value (1,000,000 in this case), it resets the counter and toggles the blink state (blink_state). The LEDs are then set to either the temporary LED pattern or zero, depending on the blink state. If led_temp is zero (meaning no LEDs should be on), it ensures the LEDs are off and resets the counter.

The last line of the code initializes a 4-bit register txState to zero, which seems to be related to the transmission state of the UART module, but it's not used in the provided code snippet.