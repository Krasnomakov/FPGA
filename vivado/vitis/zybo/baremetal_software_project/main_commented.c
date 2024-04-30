#include "xparameters.h" // Include the header file that contains the auto-generated parameters for the Xilinx platform
#include "xil_printf.h" // Include the header file that provides a minimalistic printf function for the Xilinx platform
#include "xgpio.h" // Include the header file that provides functions for interacting with the General Purpose I/O (GPIO) on the Xilinx platform
#include "xil_types.h" // Include the header file that provides type definitions for the Xilinx platform

// Define constants for the button and LED device IDs, channels, and masks
#define BTN_ID XPAR_AXI_GPIO_BUTTONS_DEVICE_ID // Button device ID
#define LED_ID XPAR_AXI_GPIO_LED_DEVICE_ID // LED device ID
#define BTN_CHANNEL 1 // Button channel
#define LED_CHANNEL 1 // LED channel
#define BTN_MASK 4 // Button mask
#define LED_MASK 1 // LED mask

int main() { // Start of the main function
    XGpio_Config *cfg_ptr; // Declare a pointer to a XGpio_Config structure
    XGpio led_device, btn_device; // Declare XGpio structures for the LED and button devices
    u32 data; // Declare a 32-bit unsigned integer for data

    xil_printf("Entered function main\r\n"); // Print a message to the console indicating that the main function has been entered

    // Initialize LED Device
    cfg_ptr = XGpio_LookupConfig(LED_ID); // Look up the configuration for the LED device
    XGpio_CfgInitialize(&led_device, cfg_ptr, cfg_ptr->BaseAddress); // Initialize the LED device with the looked up configuration

    // Initialize Button Device
    cfg_ptr = XGpio_LookupConfig(BTN_ID); // Look up the configuration for the button device
    XGpio_CfgInitialize(&btn_device, cfg_ptr, cfg_ptr->BaseAddress); // Initialize the button device with the looked up configuration

    // Set Button Tristate
    XGpio_SetDataDirection(&btn_device, BTN_CHANNEL, BTN_MASK); // Set the data direction for the button device

    // Set Led Tristate
    XGpio_SetDataDirection(&led_device, LED_CHANNEL, 0); // Set the data direction for the LED device

    while (1) { // Start of an infinite loop
        data = XGpio_DiscreteRead(&btn_device, BTN_CHANNEL); // Read the state of the button device
        data &= BTN_MASK; // Apply the button mask to the read data
        if (data != 0) { // If the button is pressed
            data = LED_MASK; // Set the data to the LED mask
        } else { // If the button is not pressed
            data = 0; // Set the data to 0
        }
        XGpio_DiscreteWrite(&led_device, LED_CHANNEL, data); // Write the data to the LED device
    } // End of the infinite loop
} // End of the main function