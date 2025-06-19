.PHONY: all run build solve solve-sequential solve-parallel kill dist distrun clean deploy version lint test shell

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

export FULLNAME  = CTFd challenge name
export AUTHOR    = LosFuzzys
export CATEGORY  = pwn
define DESC
This is a multiline challenge description!

Feel free to add more lines.
endef
export DESC
export FLAG      = $(shell cat challenge/flag.txt)
export FAKE_FLAG = $(shell cat dist/flag.txt)
export TAG       = CTFd tag

############################
# Deployment Configuration #
############################

export REGISTRY = localhost
export HOST     = 127.0.0.1
# Port for private deployments
export PORT     = 1337
export TIMEOUT  = 30
# Port for public deployments
export PUBPORT  = 10000

# Slugified challenge name. Default to directory name
MKPATH:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
UNCLEAN_NAME=$(notdir ${MKPATH})
export NAME=$(shell echo ${UNCLEAN_NAME} | tr "[:upper:]" "[:lower:]")

# DO NOT TOUCH
# Major: Big features & breakage of interfaces                  (in sync)
# Minor: Small functionality changes w/ backward compatibility  (in sync)
# Patch: Small fixes specific to this template                  (not in sync)
export _VERSION = 1.0.0
export _TEMPLATE = python3.11-nojail-alpine3.19

########################
# Challenge Dockerfile #
########################

CACHEBUST=$(shell date +%s)
IT=$$([ -t 0 ] && echo "-it")

# Docker Run Args
export RARGS ?= -p ${HOST}:${PORT}:1337 -e HOST=${HOST} -e PORT=${PORT} \
	-e TIMEOUT=${TIMEOUT} --user 1337:1337 --read-only --platform linux/amd64
# Docker Build Args
export BARGS ?= --platform linux/amd64

crun:
	@echo -e "\e[1;36m[+] Running Challenge Container on ${HOST}:${PORT}\e[0m"
	${RUNTIME} run --rm --name ${NAME} ${RARGS} ${IT} ${REGISTRY}/${NAME}
	echo ${RUNTIME} run --rm --name ${NAME} ${RARGS} ${IT} ${REGISTRY}/${NAME}

cbuild:
	@echo -e "\e[1;34m[+] Building Challenge Container\e[0m"
	#${RUNTIME} build -t ${REGISTRY}/${NAME}-build --target builder ${BARGS} \
	#	${MKPATH}/challenge/
	#${RUNTIME} run  -v ${MKPATH}/dist:/dist:z ${REGISTRY}/${NAME}-build
	#cp ${MKPATH}/challenge/challenge ${MKPATH}/solution/
	${RUNTIME} build -t ${REGISTRY}/${NAME} ${BARGS} \
		--build-arg CACHEBUST=${CACHEBUST} ${MKPATH}/challenge/

ckill:
	@echo -e "\e[1;34m[+] Killing Challenge Container\e[0m"
	${RUNTIME} ps --filter "name=${NAME}" --format "{{.ID}}" \
		| tr '\n' ' ' \
		| xargs -r ${RUNTIME} stop -t 0 \
		|| true

##########################
# Challenge Distribution #
##########################

HSH := $(shell md5sum dist/sha256sum 2>/dev/null | cut -d' ' -f1)

# If tar complains about --transform, ensure you have GNU tar
TAR_GNU_RENAME := $$(tar --version | grep -i gnu > /dev/null 2>&1 && \
									echo "--transform s@^dist@${NAME}@")
TAR_BSD_RENAME := $$(tar --version | grep -i bsd > /dev/null 2>&1 && \
									echo "-s @^dist@${NAME}@")
dist: build
	@echo -e "\e[1;34m[+] Generating Distributed ${NAME}.tar.gz\e[0m"
	envsubst < ./dist/deploy.sh.template | \
		tee ./dist/deploy.sh >/dev/null
	envsubst < ./dist/deploy.bat.template | \
		tee ./dist/deploy.bat >/dev/null
	chmod +x ./dist/deploy.sh
	cd dist && find -L -type f,l -exec sha256sum '{}' \; | sed -e '/sha256sum/d' \
		-e '/deploy.sh.template/d' -e '/deploy.bat.template/d' -e '/.gitignore/d' \
		-e '/.dockerignore/d' | tee sha256sum
	tar -h --exclude 'deploy.sh.template' --exclude '.gitignore' \
		--exclude 'deploy.bat.template' --exclude '.dockerignore' \
		${TAR_GNU_RENAME} -czvf ${NAME}.tar.gz ${TAR_BSD_RENAME} dist/
	@echo -e "\e[1;34m[+] Generated Distributed ${NAME}.tar.gz\e[0m"
	@echo -n "    md5sum(dist/sha256sum): (old) ${HSH} -> (new) "
	@md5sum dist/sha256sum | cut -d' ' -f1
	@echo    "    - old == new: same challenge sources => no need to worry"
	@echo    "    - old != new: new  challenge sources => re-check distrun & solve"

# Deploy the generate dist file for testing
DIST_TARGET=
distrun:
	@echo -e "\e[1;34m[+] Deploying Distributed ${NAME}.tar.gz (${HSH})\e[0m"
	cd $(shell mktemp -d) && \
	cp ${MKPATH}/${NAME}.tar.gz . && \
	tar xf ${NAME}.tar.gz && \
	cd ${NAME} && \
	./deploy.sh ${DIST_TARGET}

#########################
# Challenge Solvescript #
#########################

# Docker Run Args
SRARGS=-e HOST=${HOST} -e PORT=${PORT} -e TIMEOUT=${TIMEOUT} \
			 --hostname localhost --net=host \
			 -v ${MKPATH}/challenge/flag.txt:/app/flag.txt:z,ro \
			 -v ${MKPATH}/challenge/flag.txt:/flag.txt:z,ro \
			 -v ${MKPATH}/dist/flag.txt:/app/flag-fake.txt:z,ro \
			 -v ${MKPATH}/dist/flag.txt:/flag-fake.txt:z,ro \
			 --platform linux/amd64
# Docker Build Args
SBARGS=--platform linux/amd64

sbuild:
	@echo -e "\e[1;34m[+] Building Solvescript Container\e[0m"
	cd solution/ ; \
	${RUNTIME} build -t ${REGISTRY}/${NAME}-solvescript ${SBARGS} .

define run_check
	cd solution/ ; \
	echo -e	"\e[1;36m>>>>>>>>>>>>>> START $$(date +'%H:%M:%S')\e[0m"; \
	exec 3>&1 ; \
	O=$$(${RUNTIME} run --rm ${SRARGS} ${2} --name ${NAME}-solvescript${1} \
		${REGISTRY}/${NAME}-solvescript 3>&- | tee /dev/fd/3) ; \
	RETVAL=$$? ; \
	exec 3>&- ; \
	echo -e	"\e[1;36m<<<<<<<<<<<<<< END $$(date +'%H:%M:%S')\e[0m"; \
	printf "$$O" | grep ${FLAG} > /dev/null 2>&1 && \
		echo -e "\033[1;32m[+] Real flag found: ${FLAG}\033[0;0m" || ( \
	printf "$$O" | grep ${FAKE_FLAG} > /dev/null 2>&1 && \
		echo -e "\033[1;32m[+] Fake flag found: ${FAKE_FLAG}\033[0;0m" \
		|| ([[ "$$RETVAL" -eq "0" ]] && \
		echo -e "\033[1;31m[!] Flag not found\033[0;0m"; exit 1))
endef

srun:
	@echo -e "\e[1;34m[+] Running Solvescript Container against" \
		"${HOST}:${PORT}\e[0m"
	@$(call run_check,,-it)

TIMES=10
srun-sequential:
	@echo -e "\e[1;34m[+] Running Sequential Container against" \
		"${HOST}:${PORT}\e[0m"
	@parallel --line-buffer --jobs 1 '$(call run_check,-sequential-{},)' \
		::: `seq -s' ' 1 1 ${TIMES}`
	
JOBS=4
srun-parallel:
	@echo -e "\e[1;34m[+] Running Parallel Container against ${HOST}:${PORT}\e[0m"
	@parallel --jobs ${JOBS} '$(call run_check,-parallel-{},)' \
		::: `seq -s' ' 1 1 ${TIMES}`

skill:
	@echo -e "\e[1;34m[+] Killing Solution Container/s\e[0m"
	${RUNTIME} ps --filter "name=${NAME}-solvescript*" --format "{{.ID}}" \
		| tr '\n' ' ' \
		| xargs -r ${RUNTIME} stop -t 0 \
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

# Deployments for podman quadlets (systemd services)
deploy-quadlet:
	@echo -e "\e[1;34m[+] Generating podman-quadlet deployment\e[0m"
	@mkdir -p ~/.config/containers/systemd/
	echo -e "[Unit]\nDescription=Challenge ${NAME}\n" > \
		~/.config/containers/systemd/chall-${NAME}.container
	${RUNTIME} run ghcr.io/containers/podlet \
		podman run --rm --name ${NAME} ${RARGS} ${REGISTRY}/${NAME} \
		>> ~/.config/containers/systemd/chall-${NAME}.container
	echo -e "\n[Service]\nRestart=always\n\n[Install]\nWantedBy=default.target" \
		>> ~/.config/containers/systemd/chall-${NAME}.container
	sed -i 's/--tty//' ~/.config/containers/systemd/chall-${NAME}.container
	sed -i 's/--interactive//' \
		~/.config/containers/systemd/chall-${NAME}.container
	@systemctl --user daemon-reload
	@echo -e "\e[1;34m[+] Genereated podman-quadlet deployment:\e[0m"
	@cat ~/.config/containers/systemd/chall-${NAME}.container
	@echo -e "\e[1;34m[+] Generated systemd service:\e[0m"
	systemctl --user status chall-${NAME} || true
	@echo -e "\e[1;34m[+] Start the container:\e[0m"
	@echo    "    systemctl --user start chall-${NAME}"
	@echo -e "\e[1;34m[+] Remember to enable (once) lingering for the user\e[0m"
	@echo    "    loginctl enable-linger $$USER"
	@echo -e "\e[1;34m[+] Target for ${NAME} is ${HOST}:${PUBPORT}\e[0m"

# Deployment for docker-compose
deploy-docker:
	@echo -e "\e[1;34m[+] Generating docker-compose deployment\e[0m"
	${RUNTIME} run ghcr.io/losfuzzys/composerize:latest \
		docker run --rm --name ${NAME} ${RARGS} ${REGISTRY}/${NAME} \
		> ${MKPATH}/deployment/docker-compose.yml
	sed -i '1 s/^.*$$/name: ctf/' ${MKPATH}/deployment/docker-compose.yml
	@echo "    restart: always" >> ${MKPATH}/deployment/docker-compose.yml
	sed -i '/tty: true/d' ${MKPATH}/deployment/docker-compose.yml
	sed -i '/stdin_open: true/d' ${MKPATH}/deployment/docker-compose.yml
	@echo -e "\e[1;34m[+] Generated docker-compose.yml deployment:\e[0m"
	@cat ${MKPATH}/deployment/docker-compose.yml
	@echo -e "\e[1;34m[+] Start the container:\e[0m"
	@echo "    docker-compose up -d -f ${MKPATH}/deployment/docker-compose.yml"
	@echo -e "\e[1;34m[+] Target for ${NAME} is ${HOST}:${PUBPORT}\e[0m"

# Deployment for registry
deploy-registry: 
	@echo -e "\e[1;34m[+] Deploying Container/s\e[0m"
	${RUNTIME} push ${REGISTRY}/${NAME}

#############
# Testsuite #
#############

define test_solve_container
	@F='1'; \
	for w in `seq -s' ' 1 1 ${TEST_TIMEOUT_UP}`; do \
		[ "`$1 ps --format 'UP' --filter "name=${NAME}"`" == "UP" ] && \
		F='0' && break || sleep 1; \
	done; \
	[ "$$F" == "1" ] && (echo -e "\e[1;31mTimeout reached\e[0m" && make kill && \
		exit 1) || true 
	echo -e "[+] make solve" || true
	@make solve >> $(TEST_LOG) 2>&1 && echo -e "\e[1;32m[+] Flag found\e[0m" || \
		(echo -e "\e[1;33m[+] Flag not found\e[0m" && make kill && exit 1)
endef

define test_fail
	(echo -e	"\e[1;31m---------------- START tail log ------------------\e[0m"; \
	tail ${TEST_LOG}; \
	echo -e	"\e[1;31m------------------ END tail log ------------------\e[0m"; \
	echo -e	"\e[1;31m[+] $1 failed.\e[0m Run \e[1;36m$1\e[0m to debug" && exit 1)
endef

TEST_TIMEOUT_UP=30
TEST_BOOT_DELAY=0
TEST_LOG := ${MKPATH}/test.log
test: test-main test-dist

test-main:
	@echo -e "\e[1;34m[+] Testing challenge\e[0m"
	@echo -e "[+] Follow logs with \e[1;33mtail -f ${TEST_LOG}\e[0m"
	@make kill > /dev/null 2>&1
	@echo -e "[+] make build"
	@make build >> $(TEST_LOG) 2>&1 || $(call test_fail,make build)
	@echo -e "[+] make run (timeout ${TEST_TIMEOUT_UP}s)"
	@make run >> $(TEST_LOG) 2>&1 &
	@[ "${TEST_BOOT_DELAY}" -eq "0" ] || \
		(echo -e "[+] wait ${TEST_BOOT_DELAY}s for the challenge to boot" && \
		sleep ${TEST_BOOT_DELAY})
	@$(call test_solve_container,${RUNTIME})
	@make kill > /dev/null 2>&1
	@${RM} ${MKPATH}/test.log

test-dist:
	@echo -e "\e[1;34m[+] Testing distributed challenge\e[0m"
	@echo -e "[+] Follow logs with \e[1;33mtail -f ${TEST_LOG}\e[0m"
	@make distrun DIST_TARGET=build >> $(TEST_LOG) 2>&1 \
		|| $(call test_fail,make distrun)
	@echo -e "[+] make distrun (timeout ${TEST_TIMEOUT_UP}s)"
	@make distrun >> $(TEST_LOG) 2>&1 &
	@[ "${TEST_BOOT_DELAY}" -eq "0" ] || \
		(echo -e "[+] wait ${TEST_BOOT_DELAY}s for the challenge to boot" && \
		sleep ${TEST_BOOT_DELAY})
	@$(call test_solve_container,${RUNTIME_DIST})
	@make kill RUNTIME=${RUNTIME_DIST} > /dev/null 2>&1
	@${RM} ${MKPATH}/test.log

###########
# Generic #
###########

SHELL := /usr/bin/env bash
export RUNTIME ?= docker
export RUNTIME_DIST ?= docker

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

define lint_assert_symlink
	@(([ ! -L ${MKPATH}/${1} ] || [ ! -e ${MKPATH}/${1} ]) && \
		echo -e "\e[0;41m[FAIL]\e[0;0m ${1} is not a valid symlink") || \
		echo "[OK  ] ${1} is a valid symlink"
endef

define lint_assert_empty
	@([ ! -s ${MKPATH}/${1} ] && \
		echo -e "\e[0;41m[FAIL]\e[0;0m ${1} is empty") || \
		echo "[OK  ] ${1} has content"
endef

lint:
	@$(call lint_assert_file_exists,challenge/flag.txt)
	@$(call lint_assert_file_exists,dist/flag.txt)
	@$(call lint_assert_file_exists,${NAME}.tar.gz)
	@$(call lint_assert_files_differ,dist/flag.txt,challenge/flag.txt)
	@$(call lint_assert_file_commited,${NAME}.tar.gz)
	@$(call lint_assert_symlink,deployment/.symlink-canary)
	@$(call lint_assert_empty,solution/WRITEUP.md)

clean:
	${RM} ${NAME}.tar.gz dist/challenge dist/deploy.sh dist/sha256sum \
		solution/challenge ctfd-${NAME}.yml
	make -C challenge clean

version:
	@echo -e "\e[1;34m[+] Template ${_TEMPLATE} version ${_VERSION}\e[0m"

shell:
	@${RUNTIME} exec -it ${NAME} /bin/sh -c "command -v bash 2>&1 > /dev/null && bash || sh"

# DO NOT TOUCH
# Temporary hotfix (hopefully) for DESCBR. Sorry for this!
define newline


endef

# vim:tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab colorcolumn=81
