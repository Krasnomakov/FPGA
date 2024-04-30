//This code makes LED LD0 flash with 0.5s period when BTN2 is pressed. 
//The code is written for the ZYBO board and uses the Xilinx SDK for development. 
//The code initializes the LED and button devices, sets the tristate for the button and LED, and then enters an infinite loop where it reads the state of the button, checks if the button is pressed, and toggles the LED state accordingly.

#include "xparameters.h"
#include "xil_printf.h"
#include "xgpio.h"
#include "xil_types.h"
#include "sleep.h" // Include sleep header for usleep function

#define BTN_ID XPAR_AXI_GPIO_BUTTONS_DEVICE_ID
#define LED_ID XPAR_AXI_GPIO_LED_DEVICE_ID
#define BTN_CHANNEL 1
#define LED_CHANNEL 1
#define BTN_MASK 4
#define LED_MASK 1

int main() {
    XGpio_Config *cfg_ptr;
    XGpio led_device, btn_device;
    u32 data;

    xil_printf("Entered function main\r\n");

    // Initialize LED Device
    cfg_ptr = XGpio_LookupConfig(LED_ID);
    XGpio_CfgInitialize(&led_device, cfg_ptr, cfg_ptr->BaseAddress);

    // Initialize Button Device
    cfg_ptr = XGpio_LookupConfig(BTN_ID);
    XGpio_CfgInitialize(&btn_device, cfg_ptr, cfg_ptr->BaseAddress);

    // Set Button Tristate
    XGpio_SetDataDirection(&btn_device, BTN_CHANNEL, BTN_MASK);

    // Set Led Tristate
    XGpio_SetDataDirection(&led_device, LED_CHANNEL, 0);

    while (1) {
        data = XGpio_DiscreteRead(&btn_device, BTN_CHANNEL);
        data &= BTN_MASK;
        if (data != 0) {
            // Toggle LED state at a specific frequency (e.g., 2 Hz)
            XGpio_DiscreteWrite(&led_device, LED_CHANNEL, LED_MASK);
            usleep(31250); // Delay for 0.5 seconds (62.5 million clock cycles)
            XGpio_DiscreteWrite(&led_device, LED_CHANNEL, 0); // Turn off LED
            usleep(31250); // Delay for 0.5 seconds (62.5 million clock cycles)
        }
    }
    return 0;
}
