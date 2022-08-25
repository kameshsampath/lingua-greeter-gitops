#!/usr/bin/env bash

set -euxo pipefail

docker network create "${DOCKER_NETWORK_NAME}" || true

drone exec --trusted --network "${DOCKER_NETWORK_NAME}"