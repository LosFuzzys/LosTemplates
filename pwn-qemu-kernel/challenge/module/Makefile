.PHONY: all

# This won't get run automatically. You can use this as a personal helper
# Do not put this in /dist

obj-m += module.o 
PWD := $(CURDIR) 

all:
	make -C ../linux/linux-6.10.2 M=$(PWD) modules 

clean: 
	make -C ../linux/linux-6.10.2 M=$(PWD) clean
