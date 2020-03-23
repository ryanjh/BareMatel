#include <stdint.h>

#define GPIO_BASE   0x50000000
#define GPIO_OUTSET (*((uint32_t*) (GPIO_BASE + 0x508)))
#define GPIO_OUTCLR (*((uint32_t*) (GPIO_BASE + 0x50C)))
#define GPIO_PIN_CNF(pin) (*((uint32_t*) (GPIO_BASE + 0x700 + pin * 4)))

unsigned int LED = 17;

int main()
{
    GPIO_PIN_CNF(LED) = 1;

    while(1)
    {
        GPIO_OUTSET = (1 << LED);
        for(int c = 0; c < 1000000; c++);
        GPIO_OUTCLR = (1 << LED);
        for(int c = 0; c < 1000000; c++);
    }
    return 0;
}