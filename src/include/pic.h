#ifndef PIC_H
#define PIC_H

#include <stdint.h>

void remap_pic(void);
void pic_send_eoi(uint8_t irq);

#endif
