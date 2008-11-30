scheme = mzscheme -M errortrace -r
asflags = -nostdlib -m32

all: urscheme

urscheme: compiler.s
	time $(CC) $(asflags) $< -o $@

compiler.s: compiler.scm
	time $(scheme) $< < $< > $@
