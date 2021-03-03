#!/bin/bash

set -e

kustomize build manifests | kubectl apply -f -

exit 0