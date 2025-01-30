# Overall BeagleBone booting sequence 

The boot sequence of the BeagleBone (such as the BeagleBone Black or BeagleBone AI) involves several stages to bring up the system. Here’s an overview of the boot process:

------

### **1. Power On Reset (POR):**

- When powered on or reset, the processor initializes its hardware and starts executing the boot ROM.

------

### **2. Boot ROM Execution:**

- The boot ROM is a small piece of firmware embedded in the processor. It determines the boot source based on the boot pin configuration.
- The boot sources can include:
  - **eMMC**
  - **microSD card**
  - **USB**
  - **Serial (UART)**
  - **Network (Ethernet)**
- The order of boot sources is determined by the **SYSBOOT** pins, which are set on the board.

#### 4 boot modes

- **eMMC Boot**…This is the default boot mode and will allow for the fastest boot
  time and will enable the board to boot out of the box using the pre-flashed OS
  image without having to purchase an microSD card or an microSD card writer.
- **SD Boot**…This mode will boot from the microSD slot. This mode can be used to
  override what is on the eMMC device and can be used to program the eMMC
  when used in the manufacturing process or for field updates.
- **Serial Boot**…This mode will use the serial port to allow downloading of the
  software direct. A separate USB to serial cable is required to use this port.
- **USB Boot**…This mode supports booting over the USB port.

A switch is provided to allow switching between the modes.

- Holding the boot switch down during a removal and reapplication of power
  without a microSD card inserted will force the boot source to be the USB port
  and if nothing is detected on the USB client port, it will go to the serial port
  for download.
- Without holding the switch, the board will boot try to boot from the eMMC. If
  it is empty, then it will try booting from the microSD slot, followed by the
  serial port, and then the USB port.
- If you hold the boot switch down during the removal and reapplication of
  power to the board, and you have a microSD card inserted with a bootable
  image, the board will boot from the microSD card.

------

### **3. Bootloader (U-Boot):**

- Once the boot ROM identifies a valid bootloader from the selected source, it loads and executes the bootloader (typically U-Boot).
- Primary tasks of U-Boot:
  1. Hardware initialization (memory, peripherals, etc.).
  2. Loading the Linux kernel and device tree from storage or over the network.
  3. Passing boot arguments to the kernel.

------

### **4. Linux Kernel Initialization:**

- The kernel is loaded into memory and executed.
- The kernel initializes system resources, mounts the root filesystem, and starts user-space processes.

------

### **5. User-Space Initialization:**

- After kernel initialization, the `init` process is launched.
- The `init` process sets up the user-space environment, including starting services and applications based on the system's configuration (e.g., BusyBox on minimal systems).

------

### **BeagleBone-Specific Boot Sources:**

1. **microSD Card** (Common for development): If present, the BeagleBone typically prioritizes booting from the SD card.
2. **eMMC** (Internal storage): Default boot source for pre-loaded or production systems.
3. **USB**: Allows booting using the `usbboot` utility.
4. **UART**: Enables loading and executing binaries over serial (useful for debugging).
5. **Ethernet**: Supports booting via TFTP or similar network protocols.

------

### **Bootloader Customization and Debugging:**

- **Customization:** U-Boot can be modified to adjust the boot sequence, environment variables, and boot arguments.
- **Debugging:** You can monitor the boot sequence through the serial debug console.
