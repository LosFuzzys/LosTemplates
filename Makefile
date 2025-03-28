.PHONY: versions patch test

NAME_LENGTH:=30
VERSION_LENGTH:=7

versions:
	$(eval NAME_SEPERATOR := $(shell printf -- '-%.0s' {2..$(NAME_LENGTH)}))
	@printf "| %*s | %s |\n" -${NAME_LENGTH} "Name" "Version"
	@printf "| :%s | :-----: |\n" $(NAME_SEPERATOR)
	@for DIR_NAME in $(wildcard */); do \
		if [ -f $$DIR_NAME/Makefile ]; then \
			CLEANED_NAME=$$(realpath --relative-to . $$DIR_NAME); \
			VERSION=$$(awk -F "=" '/export _VERSION = ([0-9.]+)/ {print $$2}' $$DIR_NAME/Makefile); \
			printf "| %-$(NAME_LENGTH)s | %-$(VERSION_LENGTH)s |\n" $$CLEANED_NAME $$VERSION ; \
		fi \
	done

PATCH:=./name.patch
patch:
	@if [ -f ${PATCH} ]; then \
		for f in $(wildcard */) ; do \
				if [[ -d "$$f" && -f "$$f/Makefile" ]]; then \
					 echo -e "\e[1;35m[+] Patching $$f with ${PATCH}\e[0m"; \
					patch -d $$f --backup-if-mismatch -p2 < ${PATCH}; \
				fi \
		done \
	else \
		echo -e "\e[1;31m[+] ${PATCH} file does not exist"; \
	fi

test:
	@for DIR_NAME in $(wildcard */); do \
		if [ -f $$DIR_NAME/Makefile ]; then \
			echo -e "\e[1;35m[+] Testing $$DIR_NAME \e[0m"; \
			make -C $$DIR_NAME test; \
		fi \
	done

TIMEOUT_DIST=30
dist-test:
	@for DIR_NAME in $(wildcard */); do \
		if [ -f $$DIR_NAME/Makefile ]; then \
			echo -e "\e[1;35m[+] Generating dist & Testing $$DIR_NAME \e[0m"; \
			echo -e "\e[1;34m[+] Generating dist... \e[0m"; \
			timeout ${TIMEOUT_DIST} make -C $$DIR_NAME dist &>/dev/null; \
			make -C $$DIR_NAME test; \
		fi \
	done

lint:
	@for DIR_NAME in $(wildcard */); do \
		if [ -f $$DIR_NAME/Makefile ]; then \
			echo -e "\e[1;35m[+] Linting $$DIR_NAME \e[0m"; \
			make -C $$DIR_NAME lint; \
		fi \
	done

clean:
	@for DIR_NAME in $(wildcard */); do \
		if [ -f $$DIR_NAME/Makefile ]; then \
			echo -e "\e[1;35m[+] Cleaning $$DIR_NAME \e[0m"; \
			${RM} $$DIR_NAME/*.tar.gz; \
			${RM} $$DIR_NAME/*.log; \
		fi \
	done

# vim:tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab colorcolumn=81
