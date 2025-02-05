.PHONY: get_versions

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

# vim:tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab colorcolumn=81