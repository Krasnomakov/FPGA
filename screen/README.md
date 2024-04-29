![fontys_oled_tangNano.jpg](https://drive.google.com/uc?export=view&id=17m6StBCx-BkY2VH-ZPn8EpSyansv2WSS)

screen_commented.v has explicitly commented Verilog 

**Summary**
Certainly! Here's a simplified explanation suitable for a Git README:

---

# Screen Module

The Screen module is designed in Verilog for controlling a display screen. It interfaces with a microcontroller or similar device to send data and commands for display operations.

### Inputs
- `clk`: Clock signal.
  
### Outputs
- `io_sclk`: Serial clock for data transmission.
- `io_sdin`: Serial data input.
- `io_cs`: Chip select signal.
- `io_dc`: Data/command select signal.
- `io_reset`: Reset signal.

### Operation
- The module initializes by sending startup commands to the screen.
- It then loads initialization commands and sends them to configure the display.
- After initialization, it can load and send pixel data for display.

### States
- **INIT_POWER**: Initialization power-up state.
- **LOAD_INIT_CMD**: Loading initialization commands.
- **SEND**: Sending data.
- **CHECK_FINISHED_INIT**: Checking if initialization is finished.
- **LOAD_DATA**: Loading pixel data.

### Files
- `screen.v`: Verilog code for the screen module.
- `image.hex`: File containing pixel data for the display.

### Usage
1. Instantiate the `screen` module in your Verilog project.
2. Connect the inputs and outputs as per your system requirements.
3. Ensure the `image.hex` file contains valid pixel data for display.

### Note
- This module assumes the screen uses a specific communication protocol and initialization sequence. Modify as necessary for compatibility with your display. (SSD1306 driver, 4-wire SPI configuration (the screen must have 7 pins))

