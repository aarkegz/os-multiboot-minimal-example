.att_syntax

.equ    MULTIBOOT_MAGIC,    0x1BADB002
.equ    MULTIBOOT_FLAGS,    0x00010002  # bit 1 (meminfo) and bit 16 (load address header fields)
.equ    MULTIBOOT_CHECKSUM, -(MULTIBOOT_MAGIC + MULTIBOOT_FLAGS)

# The entry point of the kernel
.section .text.boot
.code32
.global _start
_start:
    mov     %eax, %edi      # The multiboot magic number
    mov     %ebx, %esi      # The multiboot information structure
    jmp     entry32

.balign 4
.type multiboot_header, @object
multiboot_header:
    .long   MULTIBOOT_MAGIC         # The magic number
    .long   MULTIBOOT_FLAGS         # The flags
    .long   MULTIBOOT_CHECKSUM      # The checksum
    .long   multiboot_header        # The header address, the linear address where the magic number should be loaded
    .long   _start                  # The start address of the kernel image, same as _start in this demo
    .long   0                       # The end address of the data segment, 0 means the end of the kernel image
    .long   0                       # The end address of the bss segment, 0 means no bss segment
    .long   _start                  # The entry point of the kernel
    # There may be other fields here if we set the bit 2 of the flags, we can safely ignore them here

.global entry32
entry32:
    # Print "Hello, World!" to the serial port COM1 (0x3F8)
    mov     $0x3F8, %dx                     # The serial port COM1
    mov     $message, %esi                  # The message to print
    mov     $(message_end - message), %ecx  # The length of the message

    rep outsb

    # For a real OS, add the following code here:
    # 1. Initialize the GDT and IDT
    # 2. Read the multiboot information structure, especially the memory map
    # 3. Set up the stack
    # 4. Enter the long mode if needed
    # 5. Go to the C/C++/Rust/... kernel entry point

    hlt

.section .data
.type message, @object
message:
    .asciz  "\nHello, World!\n"
message_end:
