//LEDs blink in a row when any button is pressed
//the loop stops when the button is released 
//each time a button is pressed blinking begins from the start 

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

    // Set Button Tristate
    XGpio_SetDataDirection(&btn_device, BTN_CHANNEL, BTN_MASK);

    // Set LED Tristate
    XGpio_SetDataDirection(&led_device, LED_CHANNEL, 0);

    while (1) {
        data = XGpio_DiscreteRead(&btn_device, BTN_CHANNEL) & BTN_MASK;

        if (data != prev_data) {
            if (data != 0) { // If any button is pressed
                u32 mask = 1;
                int i = 0;
                while(data != 0) { // Loop until no button is pressed
                    XGpio_DiscreteWrite(&led_device, LED_CHANNEL, mask);
                    usleep(BLINK_PERIOD_US);
                    i = (i + 1) % 4; // Loop back to 0 after reaching 4
                    mask = 1 << i;
                    data = XGpio_DiscreteRead(&btn_device, BTN_CHANNEL) & BTN_MASK; // Read button state again
                }
            } else { // If no button is pressed
                XGpio_DiscreteWrite(&led_device, LED_CHANNEL, 0);
            }
            prev_data = data;
        }
    }
    return 0;
}
