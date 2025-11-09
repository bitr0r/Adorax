ARCH =
SYS_CFLAGS =
MAKE =

.PHONY: all
all: target kern arch
	rm -rf target/

.PHONY: kern
kern:
	cd kern/; $(MAKE) SYS_CFLAGS="$(SYS_CFLAGS)"

.PHONY: arch
arch:
	cd arch/$(ARCH); $(MAKE) SYS_CFLAGS="$(SYS_CFLAGS)"

.PHONY: target
target:
	mkdir -p target/include/md/
	rsync -avr include/arch/$(ARCH)/* target/include/md/
