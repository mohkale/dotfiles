# In this directory you'll find a series of Dockerfiles declaring dev
# environments for my use cases. This Makefile simplifies management
# of these environments by automating the building and tagging of docker
# images from these Dockerfiles.

# Prefix is attached to the name for each image built by this repository.
PREFIX := mk-

SHELL := /bin/bash

.POSIX:
$(V).SILENT:
.PHONY: all

CWF := $(abspath $(lastword $(MAKEFILE_LIST)))
CWD := $(dir $(patsubst %/,%,$(dir $(CWF))))

SRC := $(shell find $(CWD) -type f -iname '*.docker')
SRC := $(patsubst ./%,%,$(SRC))
IMAGES := $(patsubst %.docker,%,$(SRC))

help:
	@echo "Usage: make [OPTS] {TARGET|[IMAGE]}"
	@echo
	@echo "  Build a docker image from the CWD"
	@echo
	@echo "Targets:"
	@echo "  preview/IMAGE - Precompile a Dockerfile and print to STDOUT"
	@echo
	@echo "Images:"
	@echo "  all - Build all of the following images"
	@if [ -n "$(IMAGES)" ]; then printf '  %s\n' $(IMAGES); fi

all: $(IMAGES)

# Pre-process a Dockerfile.
#
# Docker itself has a very limited configuration format. This is fine for most
# use cases but I don't enjoy not having the ability to build on or extend from
# other Dockerfiles. There are extensions such as INCLUDE+ that allow docker to
# support includes, however for my dotfiles a basic AWK function to pre-process
# the docker files is more than adequate.
define docker_preprocess #(dockerfile)
	gawk                                                                                        \
	    -v INCLUDE_MATCH='^INCLUDE (.+)$$'                                                      \
	    -v HEADER_WIDTH=100                                                                     \
        -e '                                                                                    \
	    function print_header(msg, width, _, msg_length, i) {                                   \
	        msg_length = length(msg);                                                           \
			if (msg_length + 4 >= width) {                                                      \
                printf("# %s #\n", msg);                                                        \
				return;                                                                         \
			};                                                                                  \
			padding = (width - msg_length - 2) / 2;                                             \
			for (i = 0; i < padding; i++) {                                                     \
				printf("#");                                                                    \
            };                                                                                  \
			printf(" %s ", msg);                                                                \
			i += msg_length + 2;                                                                \
			for (; i < width; i++) {                                                            \
				printf("#");                                                                    \
            };                                                                                  \
			printf("\n");                                                                       \
	    }'                                                                                      \
	    -e '                                                                                    \
	    function include(current_file, target, _, filename, dir, rc, a) {                       \
	        if ((("dirname " current_file) | getline dir) == -1) {                              \
	            print "error: failed to determine cwd for " current_file > /dev/stderr;         \
	            exit 1;                                                                         \
	        };                                                                                  \
	        filename = dir "/" target;                                                          \
	        print_header("Import " filename, HEADER_WIDTH);                                     \
	        while (1) {                                                                         \
	            rc = (getline line < filename);                                                 \
	            if (rc == -1) {                                                                 \
	                print "error: could not read from " filename " for include" >/dev/stderr;   \
	                exit 1;                                                                     \
	            } else if (rc == 0) {                                                           \
	                print("");                                                                  \
	                close(filename);                                                            \
	                break;                                                                      \
	            }                                                                               \
	                                                                                            \
	            if (match(line, INCLUDE_MATCH, a)) {                                            \
	                include(filename, a[1]);                                                    \
	            } else {                                                                        \
	                print(line);                                                                \
	            }                                                                               \
	        }                                                                                   \
	        print_header("Imported " filename, HEADER_WIDTH);                                   \
	    }'                                                                                      \
	    -e '                                                                                    \
	    match($$0, INCLUDE_MATCH, a) {                                                          \
	        include(FILENAME, a[1]);                                                            \
	        next;                                                                               \
	    }'                                                                                      \
	    -e '{ print }'                                                                          \
	    "$(1)"
endef

preview/%: %.docker
	@echo "PCC $<"
	$(call docker_preprocess,"$<") |            \
	  preview -l dockerfile -

%: %.docker
	@echo "CC $<"
	set -e -o pipefail;                                     \
	$(call docker_preprocess,"$<") |                        \
	    if command -v sponge >/dev/null 2>&1; then          \
	        sponge;                                         \
	    else                                                \
	        tmp=$$(mktemp) || exit 1;                       \
	        trap 'rm '"$$tmp" EXIT;                         \
	        cat > "$$tmp";                                  \
	        cat "$$tmp";                                    \
	    fi |                                                \
	(                                                       \
	    cd ../../../;                                       \
	    docker build                                        \
	        --compress                                      \
	        --file -                                        \
	        --tag "$(PREFIX)$$(echo "$@" | sed 's / - g')"  \
	        .                                               \
	)
