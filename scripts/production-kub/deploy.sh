#
# Builds, publishes and deploys all microservices to a production Kubernetes instance.
#
# Usage:
#
#   ./scripts/production-kub/deploy.sh
#

set -u # or set -o nounset
: "$CONTAINER_REGISTRY"

#
# If you're building from Apple Silicon (ARM64) for AKS (typically AMD64),
# you must build linux/amd64 images.
#
PLATFORM=${PLATFORM:-linux/amd64}

#
# Build Docker images.
#
docker buildx build --platform $PLATFORM -t $CONTAINER_REGISTRY/metadata:1 --push --file ../../metadata/Dockerfile-prod ../../metadata

docker buildx build --platform $PLATFORM -t $CONTAINER_REGISTRY/history:1 --push --file ../../history/Dockerfile-prod ../../history

docker buildx build --platform $PLATFORM -t $CONTAINER_REGISTRY/mock-storage:1 --push --file ../../mock-storage/Dockerfile-prod ../../mock-storage

docker buildx build --platform $PLATFORM -t $CONTAINER_REGISTRY/video-streaming:1 --push --file ../../video-streaming/Dockerfile-prod ../../video-streaming

docker buildx build --platform $PLATFORM -t $CONTAINER_REGISTRY/video-upload:1 --push --file ../../video-upload/Dockerfile-prod ../../video-upload

docker buildx build --platform $PLATFORM -t $CONTAINER_REGISTRY/gateway:1 --push --file ../../gateway/Dockerfile-prod ../../gateway

docker buildx build --platform $PLATFORM -t $CONTAINER_REGISTRY/advertise:1 --push --file ../../advertise/Dockerfile-prod ../../advertise

# 
# Deploy containers to Kubernetes.
#
# Don't forget to change kubectl to your production Kubernetes instance
#
kubectl apply -f rabbit.yaml
kubectl apply -f mongodb.yaml 
envsubst < metadata.yaml | kubectl apply -f -
envsubst < history.yaml | kubectl apply -f -
envsubst < mock-storage.yaml | kubectl apply -f -
envsubst < video-streaming.yaml | kubectl apply -f -
envsubst < video-upload.yaml | kubectl apply -f -
envsubst < gateway.yaml | kubectl apply -f -
envsubst < advertise.yaml | kubectl apply -f -