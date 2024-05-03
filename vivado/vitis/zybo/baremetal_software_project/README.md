**LED_blink_inARow.c** 
This file contains the main function that controls the LED blinking in a row on the Zybo Z7 board. The blinking period is defined by the BLINK_PERIOD_US constant.

**LED_LSFR_flashing copy.c** 
This code utilises LFSR to make a random number of LEDs flash when a button is pressed.
Buttons 0, 1, 2 call for different blink periods, while button 3 is not used.
After a button is pressed and released, the LEDs will continue to flash at the same rate until another button is pressed.


**LED_LFSR_flashing.c** 
This file controls the LED flashing based on a Linear Feedback Shift Register (LFSR) algorithm. The blinking period can be adjusted with the BLINK_PERIOD_US_BTN0 and BLINK_PERIOD_US_BTN1 constants.

**LED_LFSR.c**
This file contains the main function that controls the LED flashing based on a Linear Feedback Shift Register (LFSR) algorithm. The blinking period is defined by the BLINK_PERIOD_US constant.

**main_commented.c**
This is a version of the main file with detailed comments explaining each part of the code.

**main_flashing.c:**
This file makes LED LD0 flash with a 0.5s period when BTN2 is pressed. The code is written for the ZYBO board and uses the Vitis for development.

**main.c:**
This is the main file that initializes the LED and button devices, sets the tristate for the button and LED, and then enters an infinite loop where it reads the state of the button, checks if the button is pressed, and toggles the LED state accordingly.
