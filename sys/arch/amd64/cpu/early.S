/*
 * Early bootup code
 * Copyright (c) 2025, Ian Moffett and the Adorax team.
 * All rights reserved.
 * Provided under the BSD 3-Clause license.
 */

#include <md/mb.h>

    /* Page tables */
    .set PML4T_BASE,  0x1000
    .set PDPT_BASE,   0x2000
    .set PDT_BASE,    0x3000
    .set PT_BASE,     0x4000
    .set PAGE_TBLSZ,  4096
    .set PT_ADDR_MASK, 0xFFFFFFFFFF000
    .set PT_PRESENT,    1
    .set PT_READABLE,   2
    .set PT_ENTRY_SIZE, 8
    .set PAGE_SIZE,     0x1000

    .set CR4_PAE_EN,    0x20
    .set EFER_LM_EN,    0x100
    .set IA32_EFER,     0xC0000080
    .set CR0_LM_EN,     0x80000001

    .set STACK_SIZE, 4096
    .set ARCH_FLAGS, 0x00
    .set FB_TAG,     0x00
    .set FB_WIDTH,   640
    .set FB_HEIGHT,  480
    .set FB_BPP,     32

    .section .multiboot
    .align 8
mbhdr:
    .long MULTIBOOT2_HEADER_MAGIC
    .long ARCH_FLAGS
    .long mbhdr_end - mbhdr
    .long -(MULTIBOOT2_HEADER_MAGIC + ARCH_FLAGS + (mbhdr_end - mbhdr))
    .long -(MULTIBOOT2_HEADER_MAGIC + ARCH_FLAGS + (mbhdr_end - mbhdr))
fbtag:
    .short MULTIBOOT_HEADER_TAG_FRAMEBUFFER
    .short MULTIBOOT_HEADER_TAG_OPTIONAL
    .long fbtag_end - fbtag
    .long FB_WIDTH
    .long FB_HEIGHT
    .long FB_BPP
fbtag_end:
    .align 8
    .word 0
    .word 0
    .long 8
mbhdr_end:

/* 64-bit flat GDT */
GDT64:
.gdtNull:                           /* ---- */
    .quad 0x0000000000000000        /* NULL */
.gdtCode:                           /* ---- */
    .quad 0x00209A0000000000        /* CODE */
.gdtData:                           /* ---- */
    .quad 0x0000920000000000        /* DATA */

    .align 4
GDTR:
    .word . - GDT64 - 1
    .long GDT64

    .code32
    .text
    .globl _start

/*
 * ENTRYPOINT
 */
_start:
    call zero_tables
    call link_tables

    /* Switch address spaces */
    mov $PML4T_BASE, %eax
    mov %eax, %cr3

    mov %cr4, %eax          /* CR4 -> EAX */
    or $CR4_PAE_EN, %eax    /* CR4.PAE=1 */
    mov %eax, %cr4          /* EAX -> CR4 */

    /* Set IA32_EFER.LM */
    mov $IA32_EFER, %ecx
    rdmsr
    or $EFER_LM_EN, %eax
    wrmsr

    mov %cr0, %eax
    or $CR0_LM_EN, %eax     /* PG+PM */
    mov %eax, %cr0

    lgdt GDTR
    jmp $0x08, $thunk64

link_tables:
    mov $PML4T_BASE, %edi

    /* Move and mask PDPT */
    mov $PDPT_BASE, %ebx
    and $PT_ADDR_MASK, %ebx
    or $PT_PRESENT, %ebx
    or $PT_READABLE, %ebx
    mov %ebx, (%edi)

    mov $PDPT_BASE, %edi

    /* Move and mask PDPT */
    mov $PDT_BASE, %ebx
    and $PT_ADDR_MASK, %ebx
    or $PT_PRESENT, %ebx
    or $PT_READABLE, %ebx
    mov %ebx, (%edi)

    mov $PDT_BASE, %edi

    /* Move and mask PDT  */
    mov $PT_BASE, %ebx
    and $PT_ADDR_MASK, %ebx
    or $PT_PRESENT, %ebx
    or $PT_READABLE, %ebx
    mov %ebx, (%edi)

    /* Begin filling */
    mov $PT_BASE, %edi
    mov $PT_PRESENT, %ebx
    or $PT_READABLE, %ebx
    mov $512, %ecx
.fill:
    movl %ebx, (%edi)
    add $PAGE_SIZE, %ebx
    add $PT_ENTRY_SIZE, %edi
    loop .fill
.done:
    retl

zero_tables:
    /* Zero out the PML4 */
    mov $PML4T_BASE, %edi
    mov $PAGE_TBLSZ, %ecx
    xor %eax, %eax
    rep stosl

    /* Zero out the PDPT */
    mov $PDPT_BASE, %edi
    mov $PAGE_TBLSZ, %ecx
    rep stosl

    /* Zero out the PDT */
    mov $PDT_BASE, %edi
    mov $PAGE_TBLSZ, %ecx
    rep stosl

    /* Zero out the PT */
    mov $PT_BASE, %edi
    mov $PAGE_TBLSZ, %ecx
    rep stosl
    retl

    .code64
    .extern kentry
thunk64:
    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

    xor %rbp, %rbp      /* Terminate callstack */
    mov $stack, %rsp    /* Set stack base */
    add $4095, %rsp     /* Adjust to stack top */
    jmp kentry          /* Jump to kernel */

    .section .bss
    .align 16
stack: .fill 4096, 1, 0
