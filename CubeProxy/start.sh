#!/bin/bash
# CubeProxy container entrypoint.
#
# Layout:
#   - Foreground: openresty/nginx (PID 1's main duty after exec)
#   - Background: crond, log rotation
#
# The auto-pause / auto-resume coordination that used to run in-container
# as cube-proxy-sidecar is now the responsibility of the standalone
# cube-lifecycle-manager service. This image is a pure nginx runtime.

set -u

/usr/sbin/crond
exec /usr/local/openresty/nginx/sbin/nginx
