.PHONY: all run build solve solve-sequential solve-parallel kill dist distrun clean deploy version lint

# Targets
all: build run
run: crun
build: cbuild
solve: sbuild srun
solve-sequential: sbuild srun-sequential
solve-parallel: sbuild srun-parallel
kill: ckill skill

######################
# CTFd Configuration #
######################

export FULLNAME = CTFd challenge name
export AUTHOR   = LosFuzzys
export CATEGORY = pwn
define DESC
This is a multiline challenge description!

Feel free to add more lines.
endef
export DESC
export FLAG     = $(shell cat challenge/flag.txt)
export TAG      = CTFd tag

############################
# Deployment Configuration #
############################

export REGISTRY = localhost
export HOST     = 127.0.0.1
# Port for private deployments
export PORT     = 1337
export TIMEOUT  = 30
# Port for public deployments
# export PUBPORT  = 10000

# Slugified challenge name. Default to directory name
MKPATH:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
UNCLEAN_NAME=$(notdir ${MKPATH})
export NAME=$(shell echo ${UNCLEAN_NAME} | tr "[:upper:]" "[:lower:]")

# DO NOT TOUCH
# Major: Big features & breakage of interfaces                  (in sync)
# Minor: Small functionality changes w/ backward compatibility  (in sync)
# Patch: Small fixes specific to this template                  (not in sync)
export _VERSION = 1.0.0
export _TEMPLATE = offline

########################
# Challenge Dockerfile #
########################

#CACHEBUST=$(shell date +%s)

# Docker Run Args
#export RARGS ?= -p ${HOST}:${PORT}:1337 -t -i -e HOST=${HOST} -e PORT=${PORT} \
#	-e TIMEOUT=${TIMEOUT} --read-only --privileged \
#	--platform linux/amd64
# Docker Build Args
#export BARGS ?= --platform linux/amd64 --build-arg CACHEBUST=${CACHEBUST}

crun:
	@echo -e "\e[1;34m[+] (crun) Not implemented in this template\e[0m"

cbuild:
	@echo -e "\e[1;34m[+] (cbuild) Not implemented in this template\e[0m"

ckill:
	@echo -e "\e[1;34m[+] (ckill) Not implemented in this template\e[0m"

##########################
# Challenge Distribution #
##########################

HSH := $(shell md5sum dist/sha256sum 2>/dev/null | cut -d' ' -f1)

# If tar complains about --transform, ensure you have GNU tar
dist: build
	@echo -e "\e[1;34m[+] Generating Distributed ${NAME}.tar.gz\e[0m"
	cd dist && find -L -type f,l -exec sha256sum '{}' \; | sed -e '/sha256sum/d' \
		-e '/deploy.sh.template/d' -e '/deploy.bat.template/d' -e '/.gitignore/d' \
		-e '/.dockerignore/d' | tee sha256sum
	tar -h --exclude 'deploy.sh.template' --exclude '.gitignore' \
		--exclude 'deploy.bat.template' --exclude '.dockerignore' \
		--transform s@^dist@${NAME}@ -czvf ${NAME}.tar.gz dist/
	@echo -e "\e[1;34m[+] Generated Distributed ${NAME}.tar.gz\e[0m"
	@echo -n "    md5sum(dist/sha256sum): (old) ${HSH} -> (new) "
	@md5sum dist/sha256sum | cut -d' ' -f1
	@echo    "    - old == new: same challenge sources => no need to worry"
	@echo    "    - old != new: new  challenge sources => re-check distrun & solve"

# Deploy the generate dist file for testing
distrun:
	@echo -e "\e[1;34m[+] (distrun) Not implemented in this template\e[0m"

#########################
# Challenge Solvescript #
#########################

# Docker Run Args
SRARGS=-e HOST=${HOST} -e PORT=${PORT} -e TIMEOUT=${TIMEOUT} \
			 --hostname localhost --net=host \
			 -v ${MKPATH}/challenge/flag.txt:/app/flag.txt:z,ro \
			 -v ${MKPATH}/challenge/flag.txt:/flag.txt:z,ro \
			 --platform linux/amd64
# Docker Build Args
SBARGS=--platform linux/amd64

sbuild:
	@echo -e "\e[1;34m[+] Building Solvescript Container\e[0m"
	rm -f solution/encrypted.b64
	cp challenge/encrypted.b64 solution/
	cd solution/ ; \
	docker build -t ${REGISTRY}/${NAME}-solvescript ${SBARGS} .

srun:
	@echo -e "\e[1;34m[+] Running Solvescript Container against" \
		"${HOST}:${PORT}\e[0m"
	cd solution/ ; \
	docker run --rm ${SRARGS} -it \
		--name ${NAME}-solvescript ${REGISTRY}/${NAME}-solvescript

TIMES=10
srun-sequential:
	@echo -e "\e[1;34m[+] (srun-sequential) Not implemented in this template\e[0m"
	
JOBS=2
srun-parallel:
	@echo -e "\e[1;34m[+] (srun-parallel) Not implemented in this template\e[0m"

skill:
	@echo -e "\e[1;34m[+] Killing Solution Container/s\e[0m"
	docker ps --filter "name=${NAME}-solvescript*" --format "{{.ID}}" \
		| tr '\n' ' ' \
		| xargs docker stop -t 0 \
		|| true

########################
# Challenge Deployment #
########################
deploy: deploy-registry

DESCBR=$(subst $(newline),<br />,${DESC})
export DESCBR
deploy-yml:
	@echo -e "\e[1;34m[+] Generating CTFd challenge yml\e[0m"
	envsubst < ${MKPATH}/deployment/ctfd-entry.yml.template | \
		tee ${MKPATH}/deployment/ctfd-${NAME}.yml >/dev/null

# Deployments is prepared for quadlets (containers + systemd services)
# https://www.redhat.com/sysadmin/quadlet-podman
# - Assuming running user is the one that is operating this Makefile
# - Remember to enable lingering for the user: loginctl enable-linger $USER
# - Configure this user with the minimum privileges (not in sudoers)
#
# The service will automatically be enabled after reboot due to the [Install]
# target in the quadlet/systemd service. So, reboot the machine or start it
# once, and then it will always be running unless stopped.
deploy-quadlet:
	@echo -e "\e[1;34m[+] (deploy-quadlet) Not implemented in this template\e[0m"

deploy-registry: 
	@echo -e "\e[1;34m[+] (deploy-registry) Not implemented in this template\e[0m"

###########
# Generic #
###########

define lint_assert_file_exists
	@([ ! -f ${MKPATH}/${1} ] && \
		echo -e "\e[0;41m[FAIL]\e[0;0m ${1} missing") || \
		echo "[OK  ] ${1} exists"
endef

define lint_assert_files_differ
	@((diff ${MKPATH}/${1} ${MKPATH}/${2} &>/dev/null) && \
		echo -e "\e[0;41m[FAIL]\e[0;0m ${1} and ${2} are equivalent") || \
		echo "[OK  ] ${1} and ${2} are different"
endef

define lint_assert_file_commited
	git show HEAD:${MKPATH}/${1} &>/dev/null; \
	([[ "$?" != 0 ]] && \
		echo -e "\e[0;41m[FAIL]\e[0;0m ${1} not commited in git") || \
		echo "[OK  ] ${1} commited in git"
endef

lint:
	@$(call lint_assert_file_exists,challenge/flag.txt)
	@$(call lint_assert_file_exists,dist/flag.txt)
	@$(call lint_assert_file_exists,${NAME}.tar.gz)
	@$(call lint_assert_files_differ,dist/flag.txt,challenge/flag.txt)
	@$(call lint_assert_file_commited,${NAME}.tar.gz)

clean:
	${RM} ${NAME}.tar.gz dist/challenge dist/deploy.sh dist/sha256sum \
		solution/challenge ctfd-${NAME}.yml
	make -C challenge clean

version:
	@echo -e "\e[1;34m[+] Template ${_TEMPLATE} version ${_VERSION}\e[0m"

# DO NOT TOUCH
# Temporary hotfix (hopefully) for DESCBR. Sorry for this!
define newline


endef

# vim:tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab colorcolumn=81
