ASMFILES = $(shell find . -name "*.S")
ASMOBJECTS = $(ASMFILES:.S=.S.o)
MISC_OBJECTS = $(shell find ../../ -name "*.o")

LD_FILE = conf/link.ld
CFLAGS = -I../../target/include/  $(SYS_CFLAGS)
CC = clang

.PHONY: all
all: $(ASMOBJECTS)
	ld.lld -T$(LD_FILE) $(MISC_OBJECTS) -o adorax.sys

%.S.o: %.S
	$(CC) -c $(CFLAGS) $< -o $@
