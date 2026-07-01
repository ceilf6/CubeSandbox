# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 Tencent. All rights reserved.
#
# Multi-stage build for cube-lifecycle-manager — the standalone service that
# owns sandbox auto-pause / auto-resume coordination between CubeMaster,
# CubeProxy and Redis. It supersedes the older in-container cube-proxy-sidecar
# with an unchanged wire protocol (admin push + /_sidecar_resume callback).
#
# Usage:
#   docker build -t cube-lifecycle-manager:one-click .
#   docker run --network=host \
#     -e CUBE_LCM_REDIS_ADDR=127.0.0.1:6379 \
#     -e CUBE_LCM_CUBEMASTER_URL=http://127.0.0.1:8089 \
#     cube-lifecycle-manager:one-click

# ── Build stage ────────────────────────────────────────────────────────────
FROM golang:1.25-alpine AS builder

WORKDIR /src

# Cache dependency downloads: copy manifests first, then run go mod download,
# so a source-only change doesn't invalidate the module layer.
COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go mod download

COPY cmd/     cmd/
COPY internal/ internal/

# Static, PIE-free binary so the distroless runtime (no libc) can exec it.
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags "-s -w" \
      -o /out/cube-lifecycle-manager ./cmd/cube-lifecycle-manager

# ── Runtime stage ──────────────────────────────────────────────────────────
FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /out/cube-lifecycle-manager /usr/local/bin/cube-lifecycle-manager

# The HTTP listener (/internal/resume + /healthz + /readyz).
EXPOSE 8083

USER nonroot:nonroot

ENTRYPOINT ["/usr/local/bin/cube-lifecycle-manager"]
