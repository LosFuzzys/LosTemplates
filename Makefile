.PHONY: get_versions patch

NAME_LENGTH:=30
VERSION_LENGTH:=7

get_versions:
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

export FOUND_DIFF=0
export FOUND_DIFF_CONTENT=
patch:
	@for DIR_NAME in $(wildcard */); do \
		if [ -f $$DIR_NAME/Makefile ]; then \
			DIFF=$$(git diff $$DIR_NAME); \
			if [ ! -z "$$DIFF" ]; then \
				echo -e "\e[1;34m[+] Found diff in $$DIR_NAME\e[0m"; \
				if [ "$$FOUND_DIFF" == "0" ]; then \
					FOUND_DIFF="$$DIR_NAME"; \
					FOUND_DIFF_CONTENT="$$DIFF"; \
				else \
					echo -e "\e[1;33m[+] Cannot have changes in two templates! ABORT\e[0m"; \
					exit 1; \
				fi \
			fi \
		fi \
	done; \
	for DIR_NAME in $(wildcard */); do \
		if [ -f $$DIR_NAME/Makefile ]; then \
			if [ "$$DIR_NAME" == "$$FOUND_DIFF" ]; then \
				echo -e "\e[1;34m[+] Skipping $$DIR_NAME due to it is the source of the patch\e[0m"; \
			else \
				echo -e "\e[1;34m[+] Patching $$DIR_NAME\e[0m"; \
				echo "$$FOUND_DIFF_CONTENT" | patch -d $$DIR_NAME --backup-if-mismatch -p2; \
			fi \
		fi \
	done;

# vim:tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab colorcolumn=81
