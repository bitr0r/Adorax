ASMFILES = $(shell find . -name "*.S")
ASMOBJECTS = $(ASMFILES:.S=.S.o)

LD_FILE = conf/link.ld
CFLAGS = -I../../target/include/  $(SYS_CFLAGS)
CC = clang

.PHONY: all
all: $(ASMOBJECTS)
	ld.lld -T$(LD_FILE) $^ -o adorax.sys

%.S.o: %.S
	$(CC) -c $(CFLAGS) $< -o $@
