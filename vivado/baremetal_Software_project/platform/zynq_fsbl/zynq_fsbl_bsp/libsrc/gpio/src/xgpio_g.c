#include "xgpio.h"

XGpio_Config XGpio_ConfigTable[] __attribute__ ((section (".drvcfg_sec"))) = {

	{
		"xlnx,axi-gpio-2.0", /* compatible */
		0x41200000, /* reg */
		0x0, /* xlnx,interrupt-present */
		0x0, /* xlnx,is-dual */
		0xffff, /* interrupts */
		0xffff, /* interrupt-parent */
		0x4 /* xlnx,gpio-width */
	},
	{
		"xlnx,axi-gpio-2.0", /* compatible */
		0x41210000, /* reg */
		0x0, /* xlnx,interrupt-present */
		0x0, /* xlnx,is-dual */
		0xffff, /* interrupts */
		0xffff, /* interrupt-parent */
		0x4 /* xlnx,gpio-width */
	},
	 {
		 NULL
	}
};