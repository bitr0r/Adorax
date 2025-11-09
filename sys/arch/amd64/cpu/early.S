/*
 * Early bootup code
 * Copyright (c) 2025, Ian Moffett and the Adorax team.
 * All rights reserved.
 * Provided under the BSD 3-Clause license.
 */

#include <md/mb.h>

	.set STACK_SIZE, 4096
	.set ARCH_FLAGS, 0x00
	.set FB_TAG,	 0x00
	.set FB_WIDTH,   640
	.set FB_HEIGHT,  480
	.set FB_BPP,	 32

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

	.text
	.globl _start
_start:
	cli
	hlt
1:  jmp 1b
