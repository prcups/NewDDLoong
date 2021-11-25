CC := loongarch64-linux-gnu-gcc
AS := loongarch64-linux-gnu-as
QEMU := qemu-system-loongarch64

.PHONY : build run debug run-nogui

build: kernel.bin
	$(AS) boot.s -o boot.o
	$(CC) -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra -g
	$(CC) -T linker.ld -o kernel.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc -g

run-nogui: build
	$(QEMU) -bios loongarch_bios.bin -kernel kernel.bin -nographic

debug: build
	$(QEMU) -S -s -bios loongarch_bios.bin -kernel kernel.bin

run: build
	$(QEMU) -bios loongarch_bios.bin -kernel kernel.bin

clean:
	rm *.o *.bin
