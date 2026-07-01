# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 Tencent. All rights reserved.
#
# cube-lifecycle-manager build entry point.
#
# Targets:
#   build   -> bin/cube-lifecycle-manager (host toolchain, quick dev loop)
#   test    -> go test ./...
#   image   -> docker build (produces cube-lifecycle-manager:one-click)
#   clean   -> rm bin/

ifeq ($(V),1)
Q =
msg =
else
Q = @
msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
MAKEFLAGS += --no-print-directory
endif

CURDIR       := $(shell pwd)
BIN_DIR      := $(CURDIR)/bin
BIN          := $(BIN_DIR)/cube-lifecycle-manager

IMAGE_NAME   ?= cube-lifecycle-manager
IMAGE_TAG    ?= one-click
IMAGE        := $(IMAGE_NAME):$(IMAGE_TAG)

# Static linux/amd64 binary matches what the Dockerfile ultimately ships.
GO_BUILD_ENV := CGO_ENABLED=0 GOOS=linux GOARCH=amd64
GO_LDFLAGS   := -s -w

.PHONY: all build test image clean
all: build

build:
	$(call msg,BUILD,$(BIN))
	$(Q)mkdir -p $(BIN_DIR)
	$(Q)$(GO_BUILD_ENV) go build -trimpath -ldflags "$(GO_LDFLAGS)" \
		-o $(BIN) ./cmd/cube-lifecycle-manager

test:
	$(call msg,TEST,./...)
	$(Q)go test ./...

image:
	$(call msg,DOCKER,$(IMAGE))
	$(Q)DOCKER_BUILDKIT=1 docker build -t $(IMAGE) .

clean:
	$(Q)rm -rf $(BIN_DIR)
