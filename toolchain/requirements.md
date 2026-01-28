# Toolchain Requirements

This document defines the tools required to build, flash, and debug the
`baremetal-stm32` project.

The goal is **reproducible bring-up**, not toolchain novelty. Versions are
intentionally pinned and documented.

---

## Host Environment

- **OS:** Linux (native or WSL)
- **Shell:** bash or compatible
- **USB Access:** Required for ST-LINK

---

## Required Tools

### Compiler

- **Tool:** GNU Arm Embedded GCC
- **Purpose:** Compile C code for Cortex-M targets

**Install (Ubuntu / WSL):**

```bash
sudo apt install -y gcc-arm-none-eabi
```

**Verify:**

```bash
arm-none-eabi-gcc --version
```

---

### Linker & Binary Utilities

- **Tools:** GNU Binutils (arm-none-eabi)
- **Purpose:** Link firmware and manipulate ELF/binary artifacts
- **Key tools used:** `ld`, `objcopy`, `objdump`, `readelf`

**Install (Ubuntu / WSL):**

```bash
sudo apt install -y binutils-arm-none-eabi
```

**Verify:**

```bash
arm-none-eabi-ld --version
arm-none-eabi-objcopy --version
```

---

### Debugger

- **Tool:** gdb-multiarch
- **Purpose:** Source-level debugging via OpenOCD

**Install (Ubuntu / WSL):**

```bash
sudo apt install -y gdb-multiarch
```

**Verify:**

```bash
gdb-multiarch --version
```

---

### Debugger / Flashing

- **Tool:** OpenOCD
- **Purpose:** Flash firmware and provide GDB debug access via ST-LINK
- **Interface:** On-board ST-LINK (NUCLEO-F411RE)

**Install (Ubuntu / WSL):**

```bash
sudo apt install -y openocd
```

**Verify:**

```bash
openocd --version
```

---

### Build System

- **Tool:** GNU Make
- **Purpose:** Deterministic, explicit build orchestration
- **Rationale:** Simple, transparent, and widely used in embedded firmware

**Install (Ubuntu / WSL):**

```bash
sudo apt install -y make
```

**Verify:**

```bash
make --version
```

---

## Optional Tools

These tools are helpful but not required:

- `screen`, `minicom`, or `picocom` – UART terminal
- `arm-none-eabi-objdump` – binary inspection
- Logic analyzer or oscilloscope – timing/IRQ measurement

---

## Non-Requirements

The following are intentionally not required:

- STM32CubeMX
- STM32 HAL / LL libraries
- Vendor IDEs
- Auto-generated startup code
- CMake or build generators

All required behavior is implemented explicitly in this repository.

## Notes

- Tool versions known to work are recorded in toolchain/versions.txt
- If a tool is upgraded, verify behavior and update versions.txt accordingly
