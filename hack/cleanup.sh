#!/usr/bin/env bash

set -euxo pipefail

drone exec --trusted --pipeline=delete-cluster
docker network rm "${DOCKER_NETWORK_NAME}" || true
