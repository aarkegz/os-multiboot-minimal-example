OUTPUT_ARCH(i386:x86-64)

BASE_ADDRESS = 0x10000;
ENTRY(_start)

SECTIONS {
    . = BASE_ADDRESS;

    .text : ALIGN(0x1000) {
        *(.text.boot)
    }
}
