//This code utilises LFSR to make a random number of LEDs flash when a button is pressed.

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

#define BLINK_PERIOD_US 500000 // Blink period in microseconds (0.5 seconds)

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
            if (data != 0) { // If any button is pressed
                u32 mask = lfsr_next() & LED_MASK;  // Get next LFSR value and mask it
                XGpio_DiscreteWrite(&led_device, LED_CHANNEL, mask);
                usleep(BLINK_PERIOD_US);
            } else { // If no button is pressed
                XGpio_DiscreteWrite(&led_device, LED_CHANNEL, 0);
            }
            prev_data = data;
        }
    }

    return 0;
}