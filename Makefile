CC = gcc
AS = nasm
LD = ld

CFLAGS = -m32 -c -std=gnu99 -ffreestanding -O2 -Wall -Wextra -Isrc/include
ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 -T linker.ld

SRC_C = $(wildcard src/kernel/*.c) $(wildcard src/drivers/*.c)
SRC_S = src/arch/x86/boot.asm
OBJ = $(SRC_C:.c=.o) $(SRC_S:.asm=.o)

TARGET = treon_kernel

all: $(TARGET)

$(TARGET): $(OBJ)
	$(LD) $(LDFLAGS) -o $(TARGET) $(OBJ)

src/kernel/%.o: src/kernel/%.c
	$(CC) $(CFLAGS) $< -o $@

src/drivers/%.o: src/drivers/%.c
	$(CC) $(CFLAGS) $< -o $@

src/arch/x86/%.o: src/arch/x86/%.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	@echo "cleaning old junk files."
	rm -f $(OBJ) $(TARGET)

run: $(TARGET)
	@echo "running treon kernel in qemu..."
	qemu-system-i386 -kernel $(TARGET) -vga std
