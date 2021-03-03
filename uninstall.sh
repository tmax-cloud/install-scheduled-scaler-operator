#!/bin/bash

set -e

kustomize build manifests | kubectl delete -f -

exit 0