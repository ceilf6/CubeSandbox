# cube-lifecycle-manager

Standalone service that owns sandbox auto-pause / auto-resume coordination
between CubeMaster, CubeProxy and Redis.

## Responsibilities

- Bootstraps and follows the sandbox lifecycle Redis schema
  (`cube:v1:shared:sandbox:lifecycle:*`) published by CubeMaster.
- Broadcasts sandbox metadata and pause/resume state transitions to every
  live CubeProxy replica via the loopback-style admin API
  (`POST /admin/meta/upsert` / `/admin/meta/delete` / `/admin/state`).
- Polls each CubeProxy's `/admin/last_active` snapshot and drives the
  idle-timeout sweeper.
- Handles the synchronous `/internal/resume` callback CubeProxy invokes
  when a paused sandbox receives a request.

CLM is a drop-in replacement for the previous in-container
`cube-proxy-sidecar`; the wire protocol with CubeProxy is unchanged.

## Design & plan

- Design: `../design/lifecycle-manager.md`
- Rollout plan: `../plan/lifecycle-manager-plan.md`

## Build

```sh
make build   # bin/cube-lifecycle-manager (static linux/amd64)
make test    # go test ./...
make image   # cube-lifecycle-manager:one-click
```

## Configuration

All configuration is via environment variables (prefix `CUBE_LCM_`); see
`internal/config/config.go` for the authoritative list.
