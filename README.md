# FPGA
This repository contains Verilog/C examples with Tang Nano (4K/9K/20K) and Zybo Z7 

Video:
https://drive.google.com/drive/folders/1G2B-4B-L2WDTOiZBr_922YDmkcjsOWtf?usp=sharing

## fpga_project 
This directory contains several simple implementations for Tang Nano 9K. 

- blinky (original tutorial: https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-4K/examples/led.html) 
- simple functions with Verilog
- pseudo randomness with LSFR
- pseudo random with state
- calculation that takes random input and defines a LED
- An attempt to implement Travelling Salesman Problem with Verilog

## UART
This Verilog module, named "screen," orchestrates the control of a display screen, managing its initialization, setup commands, and data transmission processes synchronized with a clock signal. Through defined states and logic, it coordinates the loading of setup instructions and image data, ensuring proper screen operation within a structured framework.

https://learn.lushaylabs.com/tang-nano-9k-debugging/ 

## screen

The "screen" Verilog module governs the functionality of a display screen by orchestrating its initialization, setup commands, and data transmission processes in tandem with a clock signal. Utilizing defined states and logic, it oversees the loading of setup instructions and image data, ensuring seamless operation of the screen within a structured framework.

https://learn.lushaylabs.com/tang-nano-9k-graphics/ 
