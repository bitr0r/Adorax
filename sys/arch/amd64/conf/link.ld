ENTRY(_start)

SECTIONS {
	. = 1M;

	__kernel_start = .;
	.text ALIGN(0x1000) : {
		*(.multiboot)
		*(.text)
	}

	. += CONSTANT(MAXPAGESIZE);

    .rodata : {
        *(.rodata .rodata.*)
    } :rodata

    . += CONSTANT(MAXPAGESIZE);

    .data : {
        *(.data)
    } :data

    .bss : {
        *(COMMON)
        *(.bss .bss.*)
    } :data

    /DISCARD/ : {
        *(.eh_frame .eh_frame.*)
        *(.note .note.*)
    }
}
