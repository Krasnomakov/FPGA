This project is a collection of Verilog files and scripts for FPGA development. It uses the Gowin GW1N-9C FPGA and is designed to be run on the Tang Nano 9K board.

File Structure
- top.v, text.v, screen.v, uart.v, rows.v: These are the main Verilog files that define the logic of the FPGA design.
- text_tb.v: This is a test bench file for the text.v module.
- tangnano9k.cst: This is a constraints file for the Tang Nano 9K board.
- screen_data.lushay.json: This JSON file includes information about the files included in the project, test benches, and synthesis options.
- scripts/generate_font.js: This is a Node.js script that generates a font for the project.
- scripts/package.json: This JSON file includes information about the Node.js script, including its main file and dependencies.
- Makefile: This file includes commands for synthesizing the design, placing and routing, generating the bitstream, programming the board, generating and running the simulation, generating the font, and cleaning up build artifacts.

--

**top.v**: This is the top-level module of the design. It instantiates all other modules and connects them together. It also defines the inputs and outputs of the design, which correspond to the physical pins on the FPGA.

**text.v**: This module is responsible for generating the text that is displayed on the screen. It takes as input the ASCII value of a character and outputs the corresponding pixel data to be displayed.

**screen.v**: This module controls the overall display of the screen. It takes as input the pixel data from the text.v module and outputs it to the screen in the correct format.

**uart.v**: This module implements a UART (Universal Asynchronous Receiver Transmitter), which is used for serial communication between the FPGA and a computer. It allows the FPGA to receive text data from the computer, which is then displayed on the screen by the text.v module.

**rows.v**: This module controls the row scanning of the screen. It ensures that each row of pixels is displayed in the correct order.

Each of these Verilog files contains one or more modules, which are the basic building blocks of Verilog designs. A module can represent anything from a simple logic gate to a complex digital system. The modules in these files are interconnected to form the complete FPGA design.