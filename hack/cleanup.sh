#!/usr/bin/env bash

set -euxo pipefail

drone exec --trusted --env-file=.envrc.local --pipeline=delete-cluster
docker network rm "${DOCKER_NETWORK_NAME}" || true
rm -rf "$KUBECONFIG"
