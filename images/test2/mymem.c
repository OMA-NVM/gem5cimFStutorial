#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include <linux/io.h>
#include <linux/miscdevice.h>
#include <linux/mm.h>
#include <asm/set_memory.h>

#define DEVICE_NAME "mymem"
#define RAM_ADDRESS 0x60000000
#define RAM_SIZE 0x1000000

static void *vaddr;

static int mymem_mmap(struct file *filp, struct vm_area_struct *vma)
{
    unsigned long pfn = RAM_ADDRESS >> PAGE_SHIFT;
    unsigned long size = vma->vm_end - vma->vm_start;

    if (size > RAM_SIZE)
        return -EINVAL;

    vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
    if (remap_pfn_range(vma, vma->vm_start, pfn, size, vma->vm_page_prot))
        return -EAGAIN;

    return 0;
}

static const struct file_operations mymem_fops = {
    .owner = THIS_MODULE,
    .mmap = mymem_mmap,
};

static struct miscdevice mymem_device = {
    .minor = MISC_DYNAMIC_MINOR,
    .name = DEVICE_NAME,
    .fops = &mymem_fops,
    .mode = 0666,
};

static int __init mymem_init(void)
{
    int ret;

    vaddr = ioremap(RAM_ADDRESS, RAM_SIZE);
    if (!vaddr) {
        pr_err("ioremap failed\n");
        return -ENOMEM;
    }

    if (set_memory_uc((unsigned long)vaddr, RAM_SIZE / PAGE_SIZE)) {
        pr_err("set_memory_uc failed\n");
        iounmap(vaddr);
        return -EFAULT;
    }

    ret = misc_register(&mymem_device);
    if (ret) {
        pr_err("misc_register failed\n");
        if (set_memory_wb((unsigned long)vaddr, RAM_SIZE / PAGE_SIZE)) {
            pr_err("set_memory_wb failed\n");
        }
        iounmap(vaddr);
        return ret;
    }

    pr_info("UC memory device initialized\n");
    return 0;
}

static void __exit mymem_exit(void)
{
    misc_deregister(&mymem_device);
    
    if (set_memory_wb((unsigned long)vaddr, RAM_SIZE / PAGE_SIZE)) {
        pr_err("set_memory_wb failed\n");
    }

    iounmap(vaddr);
    pr_info("UC memory device cleaned up\n");
}

module_init(mymem_init);
module_exit(mymem_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Your Name");
MODULE_DESCRIPTION("Kernel module with character device to set memory as uncacheable");
