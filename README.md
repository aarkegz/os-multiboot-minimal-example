# A mininal Multiboot Example

## What is Multiboot?

Multiboot is a specification that defines how an operating system can be loaded by a bootloader. It defines a minimal but complete standard interface between the bootloader and the operating system kernel. A copy of the specification can be found [here](https://www.gnu.org/software/grub/manual/multiboot/multiboot.html).

Multiboot mainly targets the x86 architecture, and is supported by GNU GRUB, qemu, and other bootloaders. If you are writing your own OS kernel, it's a good idea to make it Multiboot-compliant.

## How Multiboot works

A Multiboot-compliant kernel must contain a Multiboot header, which is a data structure that contains information about the kernel, such as its content layout, entry point, and other important data. The header, which can be identified by the magic number `0x1BADB002`, must be placed within the first 8KiB of the kernel binary, and should come as early as possible in the file.

The bootloader will locate the Multiboot header and load the kernel into memory according to the information provided in the header. The bootloader will then primarily set up the environment for the kernel, and then pass control to the kernel by jumping to the entry point.

## About this example

This example demonstrates how to create a minimal Multiboot-compliant kernel that can be loaded by a bootloader. The kernel is written in pure assembly, and it is even shorter than this README file. It simply prints "Hello, World!" to the screen and then halts the CPU.

The example is designed to be as simple as possible, while still being a valid Multiboot kernel. Anyone who is familiar with assembly language and the compiler toolchain should be able to understand it. The example is also designed to be easily extensible, so you can add your own code and features as needed, or use it as a starting point for your own projects.
