CFILES = $(shell find . -name "*.c")
CFLAGS = $(SYS_CFLAGS) -MMD
OFILES = $(CFILES:.c=.o)
DFILES = $(CFILES:.c=.d)
CFLAGS = -I../target/include/ -I../../sys/include/ $(SYS_CFLAGS)
CC = clang

.PHONY: all
all: $(OFILES)

-include $(DFILES)
%.o: %.c
	$(CC) -c $(CFLAGS) -target x86_64-none $< -o $@
