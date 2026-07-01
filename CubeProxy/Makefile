VERSION     := test
DATE        := $(shell date +'%Y%m%d')
COMMIT      := $(shell git rev-parse HEAD | cut -c1-8)
IMAGE_TAG   := $(VERSION)-$(DATE)-$(COMMIT)

IMAGE_LOCAL     := cube-proxy

# The auto-pause coordination that used to live inside this image as
# cube-proxy-sidecar has moved out to the standalone cube-lifecycle-manager
# component (see ../cube-lifecycle-manager/). CubeProxy is now a pure nginx
# + Lua image; it registers itself with CLM at startup via a Redis heartbeat
# published from init_worker.

ifeq ($(V),1)
	Q =
	msg =
	QUIET =
else
	Q = @
	msg = @printf '  %-8s %s%s\n'					\
		      "$(1)"						\
		      "$(patsubst $(abspath $(OUTPUT))/%,%,$(2))"	\
		      "$(if $(3), $(3))";
	QUIET = -q
	MAKEFLAGS += --no-print-directory
endif

.PHONY: test
test: build

.PHONY: release
release: build

.PHONY: build
build:
	$(call msg,BUILD IMAGE $(IMAGE_LOCAL):$(IMAGE_TAG))
	$(Q)docker build --rm $(QUIET)			\
		-t $(IMAGE_LOCAL):$(IMAGE_TAG)		\
		.

.PHONY: clean
clean:
	@:
