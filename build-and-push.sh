#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <dockerhub-user>/lab2-app:1.0"
    exit 1
fi

IMAGE="$1"

echo "Building $IMAGE..."
docker build -t "$IMAGE" .

echo "Pushing $IMAGE..."
docker push "$IMAGE"

echo "Done."
