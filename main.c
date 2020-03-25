#include <stdint.h>
#include "SEGGER_SYSVIEW.h"
#include "SEGGER_RTT.h"

#define GPIO_BASE   0x50000000
#define GPIO_OUTSET (*((uint32_t*) (GPIO_BASE + 0x508)))
#define GPIO_OUTCLR (*((uint32_t*) (GPIO_BASE + 0x50C)))
#define GPIO_PIN_CNF(pin) (*((uint32_t*) (GPIO_BASE + 0x700 + pin * 4)))

unsigned int LED = 17;

int main()
{
    SEGGER_SYSVIEW_Conf();
    GPIO_PIN_CNF(LED) = 1;

    int a = 0;
    while(1)
    {
        SEGGER_RTT_WriteString(0, "Hello World!\n");
        SEGGER_RTT_printf(0, "received data %x\r\n",a++);
        SEGGER_SYSVIEW_RecordEnterISR();
        GPIO_OUTSET = (1 << LED);
        for(int c = 0; c < 1000000; c++);
        GPIO_OUTCLR = (1 << LED);
        for(int c = 0; c < 1000000; c++);
        SEGGER_SYSVIEW_RecordExitISR();
    }
    return 0;
}