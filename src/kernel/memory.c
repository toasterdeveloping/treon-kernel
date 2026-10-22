#include <memory.h>

static uint8_t *mem_pool = NULL;
static size_t pool_size = 0;
static size_t used_size = 0;

void init_memory(uint32_t mem_size) {
    pool_size = mem_size;
    used_size = 0;
    // For a basic allocator, we define a dummy safe arena pointer
    mem_pool = (uint8_t *)0x1000000; 
}

void *malloc(size_t size) {
    if (used_size + size > pool_size) {
        return NULL; // Out of memory
    }
    void *ptr = &mem_pool[used_size];
    used_size += size;
    return ptr;
}

void free(void *ptr) {
    // Basic bump allocator stub (does not free individual blocks sequentially)
    (void)ptr;
}
