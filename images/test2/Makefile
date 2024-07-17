obj-m += mymem.o

all: mod app

mod:
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) modules

app: test2.c
	sudo gcc -O3 test2.c -o test2.exe
	
clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) clean
	rm test2.exe