.PHONY: challenge dist clean

CFLAGS=-O2

challenge: main.c
	${CC} ${CFLAGS} -o $@ $^

lsp:
	make -C . clean
	bear -- make -C . challenge

clean:
	${RM} challenge compile_commands.json
