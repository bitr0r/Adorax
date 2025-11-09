/*
 * Kernel entrypoint
 * Copyright (c) 2025, Ian Moffett and the Adorax team.
 * All rights reserved.
 * Provided under the BSD 3-Clause license.
 */

#include <sys/types.h>
#include <md/mb.h>

void kentry(uint32_t addr);

void
kentry(uint32_t addr)
{
    for (;;);
}
