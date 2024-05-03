# FPGA
This repository contains Verilog/C projects with Tang Nano (4K/9K/20K) and Zybo Z7.
Each directory is a complete and ready to program project with one or several Verilog (.v) examples. 

My stats on HDLBits: https://hdlbits.01xz.net/wiki/Special:VlgStats/Me

## fpga_project (GOWIN EDA)
This directory contains several simple implementations for Tang Nano 9K. 

- blinky (original tutorial: https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-4K/examples/led.html) 
- simple functions with Verilog
- pseudo randomness with LSFR
- pseudo random with state
- calculation that takes random input and defines a LED
- An attempt to implement Travelling Salesman Problem with Verilog

## UART (Open-source FPGA toolchain, Yosys, OSS-CAD)
The Verilog code defines a UART module that receives and transmits data asynchronously. It implements state machines for both receiving and transmitting data, with control logic to manage timing and data flow.

https://learn.lushaylabs.com/tang-nano-9k-debugging/ 

## screen (Open-source FPGA toolchain, Yosys, OSS-CAD)
A text engine for rendering text on an OLED display was developed. It involves mapping character codes to screen pixel positions, using pre-defined font bitmaps to convert characters to pixels, and generating the pixel data for displaying text dynamically on the display.

https://learn.lushaylabs.com/tang-nano-9k-graphics/ 

## vivado (Vivado/Vitis)
Baremetal Software project with Vivado/Vitis and Zybo Z7 mainly with C. Find various implementations of C for LED-BTN combinations with randomness and different blinking periods.

## screen_text (Open-source FPGA toolchain, Yosys, OSS-CAD)
In this project, a text engine was developed to dynamically render text onto an OLED screen using pre-defined font bitmaps and mapping character positions to screen pixel addresses. The engine allows for displaying specific characters or strings by initializing memory buffers representing rows of text.
https://learn.lushaylabs.com/tang-nano-9k-creating-a-text-engine/

## screen_data (Open-source FPGA toolchain, Yosys, OSS-CAD)
In this project, the Verilog files define the logic of an FPGA design for displaying text on a screen and handling serial communication. The top.v file serves as the top-level module, text.v generates the text to be displayed, screen.v controls the overall display, uart.v manages serial communication with a computer, and rows.v ensures correct row scanning on the screen.
https://learn.lushaylabs.com/tang-nano-9k-data-visualization/
