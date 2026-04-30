# Makefile für den Kernel

# Compiler und Flags
AS = nasm
CC = i686-elf-gcc
LD = i686-elf-gcc

ASFLAGS = -f elf32
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -ffreestanding -O2 -nostdlib -lgcc

# Dateien
KERNEL = myos.bin
ISO = myos.iso

OBJS = boot.o kernel.o

# Standard-Ziel
all: $(ISO)

# Kernel bauen
$(KERNEL): $(OBJS)
	$(LD) -T linker.ld -o $@ $(LDFLAGS) $(OBJS)

# Assembler-Dateien kompilieren
%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

# C-Dateien kompilieren
%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS)

# ISO-Image erstellen (bootfähig mit GRUB)
$(ISO): $(KERNEL)
	mkdir -p isodir/boot/grub
	cp $(KERNEL) isodir/boot/$(KERNEL)
	echo 'menuentry "MyOS" {' > isodir/boot/grub/grub.cfg
	echo '    multiboot /boot/$(KERNEL)' >> isodir/boot/grub/grub.cfg
	echo '}' >> isodir/boot/grub/grub.cfg
	grub-mkrescue -o $@ isodir

# In QEMU ausführen
run: $(ISO)
	qemu-system-i386 -cdrom $(ISO)

# Aufräumen
clean:
	rm -f $(OBJS) $(KERNEL) $(ISO)
	rm -rf isodir

.PHONY: all run clean
