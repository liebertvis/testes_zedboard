/*
 * led_blink.c - Control ZedBoard AXI GPIO LEDs (LD0-LD7) at 0x41200000
 *
 * Xilinx AXI GPIO Register Map (Base Address: 0x41200000):
 *   Offset 0x00: GPIO_DATA (Channel 1 Data Register - 8-bit LEDs)
 *   Offset 0x04: GPIO_TRI  (Channel 1 Direction: 0 = Output, 1 = Input)
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

#define AXI_GPIO_BASE_ADDR  0x41200000UL
#define MAP_SIZE            4096UL
#define GPIO_DATA_OFFSET    0x00
#define GPIO_TRI_OFFSET     0x04

int main(int argc, char *argv[])
{
    int fd;
    void *map_base;
    volatile uint32_t *gpio_data;
    volatile uint32_t *gpio_tri;

    /* 1. Open /dev/mem to access physical addresses from Linux userspace */
    fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) {
        perror("Error opening /dev/mem (must run as root)");
        return EXIT_FAILURE;
    }

    /* 2. Map physical address 0x41200000 into virtual memory */
    map_base = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, AXI_GPIO_BASE_ADDR);
    if (map_base == MAP_FAILED) {
        perror("Error mapping AXI GPIO memory");
        close(fd);
        return EXIT_FAILURE;
    }

    gpio_data = (volatile uint32_t *)((uint8_t *)map_base + GPIO_DATA_OFFSET);
    gpio_tri  = (volatile uint32_t *)((uint8_t *)map_base + GPIO_TRI_OFFSET);

    /* Configure all 8 pins as outputs (0 = Output) */
    *gpio_tri = 0x00;

    /* If user passes a hex or decimal value (e.g., `led_blink 0xAA` or `led_blink 0`), set it and exit */
    if (argc > 1) {
        uint32_t val = (uint32_t)strtoul(argv[1], NULL, 0) & 0xFF;
        *gpio_data = val;
        printf("Set ZedBoard LEDs (0x41200000) to: 0x%02X\n", val);
    } else {
        /* Otherwise, run a knight-rider / binary counter animation for 10 cycles */
        printf("Blinking ZedBoard LEDs (LD0-LD7) at 0x41200000... (Press Ctrl+C to stop)\n");
        for (int i = 0; i < 8; i++) {
            uint32_t pattern = (1U << i);
            *gpio_data = pattern;
            printf("LED Pattern: 0x%02X\n", pattern);
            usleep(200000); /* 200 ms */
        }
        /* Turn all LEDs ON, wait 500ms, then turn all OFF */
        *gpio_data = 0xFF;
        usleep(500000);
        *gpio_data = 0x00;
        printf("LEDs turned OFF.\n");
    }

    /* 3. Unmap and close */
    munmap(map_base, MAP_SIZE);
    close(fd);
    return EXIT_SUCCESS;
}

