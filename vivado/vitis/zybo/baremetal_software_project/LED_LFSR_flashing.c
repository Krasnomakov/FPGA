//This code utilises LFSR to make a random number of LEDs flash when a button is pressed.
//buttons 0, 1, 2 call for different blink periods, while button 3 is not used.

#include "xparameters.h"
#include "xil_printf.h"
#include "xgpio.h"
#include "xil_types.h"
#include "sleep.h" // Include sleep header for usleep function

#define BTN_ID XPAR_AXI_GPIO_BUTTONS_DEVICE_ID
#define LED_ID XPAR_AXI_GPIO_LED_DEVICE_ID
#define BTN_CHANNEL 1
#define LED_CHANNEL 1
#define BTN_MASK 0b1111
#define LED_MASK 0b1111

// Blink period in microseconds for each button
#define BLINK_PERIOD_US_BTN0 500000 // 0.5 seconds
#define BLINK_PERIOD_US_BTN1 250000 // 0.25 seconds
#define BLINK_PERIOD_US_BTN2 125000 // 0.125 seconds
#define BLINK_PERIOD_US_BTN3 125000  // 0.0625 seconds

// LFSR parameters
#define LFSR_INIT 0xACE1u  // Any non-zero start state will work
#define LFSR_MASK 0xB400u  // Polynomial mask

u16 lfsr = LFSR_INIT;

// LFSR function
u16 lfsr_next() {
    u16 bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5)) & 1;
    return lfsr = (lfsr >> 1) | (bit << 15);
}

int main() {
    XGpio_Config *cfg_ptr;
    XGpio led_device, btn_device;
    u32 data = 0;
    u32 prev_data = 0;

    xil_printf("Entered function main\r\n");

    // Initialize LED Device
    cfg_ptr = XGpio_LookupConfig(LED_ID);
    XGpio_CfgInitialize(&led_device, cfg_ptr, cfg_ptr->BaseAddress);

    // Initialize Button Device
    cfg_ptr = XGpio_LookupConfig(BTN_ID);
    XGpio_CfgInitialize(&btn_device, cfg_ptr, cfg_ptr->BaseAddress);

    while (1) {
        data = XGpio_DiscreteRead(&btn_device, BTN_CHANNEL) & BTN_MASK;

        if (data != prev_data) {
            u32 mask = lfsr_next() & LED_MASK;  // Get next LFSR value and mask it

            // Determine blink period based on which button is pressed
            u32 blink_period_us;
            switch (data) {
                case 1: blink_period_us = BLINK_PERIOD_US_BTN0; break;
                case 2: blink_period_us = BLINK_PERIOD_US_BTN1; break;
                case 3: blink_period_us = BLINK_PERIOD_US_BTN2; break;
                case 4: blink_period_us = BLINK_PERIOD_US_BTN3; break;
                default: blink_period_us = 0; break; // No button pressed
            }

            if (blink_period_us != 0) {
                // Turn LEDs on and off indefinitely for a stroboscope-like effect
                while (1) {
                    XGpio_DiscreteWrite(&led_device, LED_CHANNEL, mask);
                    usleep(blink_period_us);
                    XGpio_DiscreteWrite(&led_device, LED_CHANNEL, 0);
                    usleep(blink_period_us);

                    // Break the loop if the button is released
                    if ((XGpio_DiscreteRead(&btn_device, BTN_CHANNEL) & BTN_MASK) != data) {
                        break;
                    }
                }
            }

            prev_data = data;
        }
    }

    return 0;
}
