OUTPUT_DIR	:= build/
KERNEL_BIN	:= $(OUTPUT_DIR)kernel.bin
KERNEL_ELF	:= $(OUTPUT_DIR)kernel.elf
SOURCE		:= multiboot.S
LINKER_SCRIPT	:= linker.lds

# Function to set variable if it has 'default' origin
# Usage: $(call set_if_default,VARIABLE,VALUE)
define set_if_default
$(if $(filter default,$(origin $(1))),$(eval $(1) = $(2)))
endef

PREFIX		?=
OBJCOPY		?= $(PREFIX)objcopy
OBJDUMP		?= $(PREFIX)objdump
GDB			?= gdb

ifneq ($(PREFIX),) # if PREFIX is set
  $(call set_if_default,LD,$(PREFIX)ld)
  $(call set_if_default,AS,$(PREFIX)as)
  $(call set_if_default,CC,$(PREFIX)gcc)
endif

# AS_FLAGS 	?= -march=i386

QEMU				?= qemu-system-x86_64
QEMU_FLAGS			?= -m 256M -smp 1 -nographic
QEMU_DEBUG_PORT		?= 1234
QEMU_DEBUG_FLAGS	?= -S -gdb tcp::$(QEMU_DEBUG_PORT)

.PHONY: run, build, just_run, debug, disasm, clean
run: build just_run

build: $(KERNEL_BIN)

just_run:
	$(QEMU) $(QEMU_FLAGS) -kernel $(KERNEL_BIN)

debug: build
	$(QEMU) $(QEMU_FLAGS) $(QEMU_DEBUG_FLAGS) -kernel $(KERNEL_BIN) &
	$(GDB) -ex "target remote localhost:$(QEMU_DEBUG_PORT)" -ex "symbol-file $(KERNEL_ELF)"

disasm: $(KERNEL_ELF)
	$(OBJDUMP) -d $(KERNEL_ELF)

clean:
	rm -rf $(OUTPUT_DIR)

$(KERNEL_BIN): $(KERNEL_ELF)
	$(OBJCOPY) --strip-all -O binary $< $@

$(KERNEL_ELF): $(SOURCE) $(LINKER_SCRIPT)
	mkdir -p $(OUTPUT_DIR)
	$(AS) $(AS_FLAGS) -o $(OUTPUT_DIR)multiboot.o $(SOURCE)
	$(LD) -T $(LINKER_SCRIPT) -o $@ $(OUTPUT_DIR)multiboot.o
