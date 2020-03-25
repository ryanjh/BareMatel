PREFIX := arm-none-eabi-

CFLAGS += -mcpu=cortex-m4 -mthumb -g3 -o0
LDFLAGS += ${CFLAGS} -nostartfiles -Wl,-Tlinker.ld

INC += -I./libs/segger_systemview/include
SEGGER = \
	./libs/segger_systemview/src/SEGGER_RTT.c \
	./libs/segger_systemview/src/SEGGER_SYSVIEW.c \
	./libs/segger_systemview/src/SEGGER_SYSVIEW_Config_NoOS.c \
	./libs/segger_systemview/src/SEGGER_RTT_printf.c \
	./libs/segger_systemview/src/SEGGER_RTT_ASM_ARMv7M.S

systemview: $(SEGGER)
	${PREFIX}gcc ${CFLAGS} $(INC) -c ./libs/segger_systemview/src/SEGGER_RTT.c -o SEGGER_RTT.o
	${PREFIX}gcc ${CFLAGS} $(INC) -c ./libs/segger_systemview/src/SEGGER_SYSVIEW.c -o SEGGER_SYSVIEW.o
	${PREFIX}gcc ${CFLAGS} $(INC) -c ./libs/segger_systemview/src/SEGGER_SYSVIEW_Config_NoOS.c -o SEGGER_SYSVIEW_Config_NoOS.o
	${PREFIX}gcc ${CFLAGS} $(INC) -c ./libs/segger_systemview/src/SEGGER_RTT_printf.c -o SEGGER_RTT_printf.o
	${PREFIX}gcc ${CFLAGS} $(INC) -c ./libs/segger_systemview/src/SEGGER_RTT_ASM_ARMv7M.S -o SEGGER_RTT_ASM_ARMv7M.o

all: build.elf build.hex build.elf.map

main.o: main.c
	${PREFIX}gcc ${CFLAGS} $(INC) -c main.c -o main.o

startup.o: startup.c
	${PREFIX}gcc ${CFLAGS} -c startup.c -o startup.o

build.elf: main.o startup.o linker.ld systemview
	${PREFIX}gcc ${LDFLAGS} main.o startup.o SEGGER_RTT.o SEGGER_SYSVIEW.o SEGGER_SYSVIEW_Config_NoOS.o SEGGER_RTT_printf.o SEGGER_RTT_ASM_ARMv7M.o -o build.elf

build.hex: build.elf
	${PREFIX}objcopy -O ihex build.elf build.hex

build.elf.map: build.elf
	${PREFIX}objdump -x -D build.elf > build.elf.map

flash: build.hex
	nrfjprog -f nrf52 --program build.hex --sectorerase -r

hexdump: build.hex
	objdump -s build.hex

.PHONY: clean flash hexdump

clean:
	rm build.elf *.o