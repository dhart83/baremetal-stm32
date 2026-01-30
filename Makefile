# Minimal Makefile
# EPIC 1 / Issue #4: Produce an ELF

# Toolchain
CC      := arm-none-eabi-gcc
LD      := arm-none-eabi-gcc
OBJCOPY := arm-none-eabi-objcopy
SIZE    := arm-none-eabi-size

# Debug
GDB 	:= gdb-multiarch

# Target
TARGET		:= minimal
BUILD   	:= build
SRC_DIR 	:= apps/minimal
LDSCRIPT 	:= boards/nucleo_f411re/linker.ld
MAPFILE		:= $(BUILD)/$(TARGET).map

# Architecture
CPU     := cortex-m4
CFLAGS  := -mcpu=$(CPU) -mthumb -O0 -g
CFLAGS  += -ffreestanding -fno-builtin
CFLAGS	+= -Wall -Wextra

LDFLAGS := -mcpu=$(CPU) -mthumb
LDFLAGS += -nostdlib
LDFLAGS += -T $(LDSCRIPT)
LDFLAGS += -Wl,-Map=$(MAPFILE)

# Sources
SRCS := $(SRC_DIR)/main.c
OBJS := $(BUILD)/main.o

# Default target
all: $(BUILD)/$(TARGET).elf

# Build directory
$(BUILD):
	mkdir -p $(BUILD)

# Compile
$(BUILD)/main.o: $(SRC_DIR)/main.c | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

# Link
$(BUILD)/$(TARGET).elf: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@

# Binary
bin: $(BUILD)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $(BUILD)/$(TARGET).bin

# Hex
hex: $(BUILD)/$(TARGET).elf
	$(OBJCOPY) -O ihex $< $(BUILD)/$(TARGET).hex

size: $(BUILD)/$(TARGET).elf
	$(SIZE) $<

# NOTE: OpenOCD must already be running in another terminal
#		for gdb to work
#
# 	openocd -f interface/stlink.cfg -f target/stm32f4x.cfg
#
gdb: $(BUILD)/$(TARGET).elf
	$(GDB) $<

# Clean
clean:
	rm -rf $(BUILD)

.PHONY: all clean bin hex size gdb
