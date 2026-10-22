#include <gdt.h>
#include <idt.h>
#include <pic.h>

void kernel_main(void) {
    init_gdt();
    remap_pic(); 
    init_idt();

    char *video_memory = (char *)0xB8000;
    
    for (int i = 0; i < 80 * 25 * 2; i += 2) {
        video_memory[i] = ' ';
        video_memory[i+1] = 0x07;
    }

    const char *str = "hello! this is the treon kernel";
    int i = 0;
    while (str[i] != '\0') {
        video_memory[i * 2] = str[i];
        video_memory[i * 2 + 1] = 0x0F;
        i++;
    }

    // enable cpu hardware interrupts globally via assembly
    __asm__ volatile("sti"); 

    while (1) {
        __asm__ volatile("hlt");
    }
}
