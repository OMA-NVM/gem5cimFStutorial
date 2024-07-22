#include <fcntl.h>
#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>

#define DEVICE "/dev/mymem"
#define RESERVED_MEM_SIZE (0x1000000)

int
main()
{
    printf("Start!\n");
    int fd;
    void *mapped_mem;

    fd = open(DEVICE, O_RDWR | O_SYNC);
    if (fd < 0) {
        perror("open");
        return -1;
    }

    mapped_mem = mmap(
        NULL, RESERVED_MEM_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (mapped_mem == MAP_FAILED) {
        perror("mmap");
        close(fd);
        return -1;
    }

    volatile unsigned int *cmd = (volatile unsigned int *)(mapped_mem);
    volatile unsigned int *rs1
        = (volatile unsigned int *)(mapped_mem + 0x100u);
    volatile unsigned int *rs2
        = (volatile unsigned int *)(mapped_mem + 0x200u);
    volatile unsigned int *dst
        = (volatile unsigned int *)(mapped_mem + 0x300u);

    *rs1 = 0xFF001234u; // rs1
    *rs2 = 0xAFA00FFFu; // rs2
    *dst = 0xDEADBEEFu; // dest

    // __asm__ __volatile__("mfence" ::: "memory");
    // __sync_synchronize();

    *cmd = 0xAAAAAAAAu; // write AND
    printf(
        "AND result: 0x%08x (should be 0x%08x)\n", *dst,
        0xFF001234u & 0xAFA00FFFu); // read dest

    *cmd = 0xBBBBBBBBu; // write OR
    printf(
        "OR result: 0x%08x (should be 0x%08x)\n", *dst,
        0xFF001234u | 0xAFA00FFFu); // read dest

    *cmd = 0xCCCCCCCCu; // write XOR
    printf(
        "XOR result: 0x%08x (should be 0x%08x)\n", *dst,
        0xFF001234u ^ 0xAFA00FFFu); // read dest


    munmap(mapped_mem, RESERVED_MEM_SIZE);
    close(fd);
    printf("Done!\n");
    return 0;
}
