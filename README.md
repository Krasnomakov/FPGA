# FPGA
This repository contains Verilog/C projects with Tang Nano (4K/9K/20K) and Zybo Z7.
Each directory is a complete and ready to program project with one or several Verilog (.v) examples. 

My stats on HDLBits: https://hdlbits.01xz.net/wiki/Special:VlgStats/Me

## fpga_project (GOWIN EDA)
This directory contains several simple implementations for Tang Nano 9K. 

- original blinky

  tutorial: https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-4K/examples/led.html

  original code: https://github.com/sipeed/TangNano-9K-example/tree/main/led
- added simple functions with Verilog
- implemented pseudo randomness with LSFR
- created pseudo random with state
- calculation that takes random input and defines a LED
- an attempt to implement constraints and initial logic for Travelling Salesman Problem with Verilog

## UART (Open-source FPGA toolchain, Yosys, OSS-CAD)
The Verilog code defines a UART module that receives and transmits data asynchronously. It implements state machines for both receiving and transmitting data, with control logic to manage timing and data flow.

tutorial: https://learn.lushaylabs.com/tang-nano-9k-debugging/

original code: https://github.com/lushaylabs/tangnano9k-series-examples/tree/master/uart

## screen (Open-source FPGA toolchain, Yosys, OSS-CAD)
A text engine for rendering text on an OLED display was developed. It involves mapping character codes to screen pixel positions, using pre-defined font bitmaps to convert characters to pixels, and generating the pixel data for displaying text dynamically on the display.

tutorial: https://learn.lushaylabs.com/tang-nano-9k-graphics/ 

original code: https://github.com/lushaylabs/tangnano9k-series-examples/tree/master/screen

## vivado (Vivado/Vitis)
Baremetal Software project with Vivado/Vitis and Zybo Z7 mainly with C. Find various implementations of C for LED-BTN combinations with randomness and different blinking periods.

tutorial: https://digilent.com/reference/programmable-logic/guides/getting-started-with-ipi

## screen_text (Open-source FPGA toolchain, Yosys, OSS-CAD)
In this project, a text engine was developed to dynamically render text onto an OLED screen using pre-defined font bitmaps and mapping character positions to screen pixel addresses. The engine allows for displaying specific characters or strings by initializing memory buffers representing rows of text.

tutorial: https://learn.lushaylabs.com/tang-nano-9k-creating-a-text-engine/

original code: https://github.com/lushaylabs/tangnano9k-series-examples/tree/master/screen_data

## screen_data (Open-source FPGA toolchain, Yosys, OSS-CAD)
In this project, the Verilog files define the logic of an FPGA design for displaying text on a screen and handling serial communication. The top.v file serves as the top-level module, text.v generates the text to be displayed, screen.v controls the overall display, uart.v manages serial communication with a computer, and rows.v ensures correct row scanning on the screen.
https://learn.lushaylabs.com/tang-nano-9k-data-visualization/
