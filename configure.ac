AC_INIT([adorax], [0.0.1], [ian@osmora.org])

AC_PROG_CC

# Target architecture and parameters
MAKE_PROG="gmake"
SYS_ARCH="amd64"
SYS_BOOTDIR="stand/limine"
ISO_NAME="adorax.iso"

# MD kernel cflags [AMD64]
SYS_AMD64_CFLAGS="-mno-80387 -mno-mmx -mno-3dnow -mno-sse -mno-sse2 -mno-red-zone \\
				  -mcmodel=kernel"

# Kernel CFLAGS
SYS_CFLAGS="-nostdinc -nostdlib -Werror=implicit -Werror=implicit-function-declaration \\
			-Werror=implicit-int -Werror=int-conversion -Werror=missing-prototypes -pedantic \\
			$SYS_AMD64_CFLAGS"


AC_SUBST(MAKE_PROG,  [$MAKE_PROG])
AC_SUBST(SYS_CFLAGS, [$SYS_CFLAGS])
AC_SUBST(SYS_ARCH,   [$SYS_ARCH])
AC_SUBST(BOOTDIR,    [$SYS_BOOTDIR])
AC_SUBST(ISO,		 [$ISO_NAME])
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
