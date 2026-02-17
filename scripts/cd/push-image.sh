#
# Publishes a Docker image.
#
# Environment variables:
#
#   CONTAINER_REGISTRY - The hostname of your container registry.
#   REGISTRY_UN - User name for your container registry.
#   REGISTRY_PW - Password for your container registry.
#   VERSION - The version number to tag the images with.
#   NAME - The name of the image to publish.
#   DIRECTORY - The directory form which to build the image.
#
# Usage:
#
#       ./scripts/cd/push-image.sh
#

set -u # or set -o nounset
: "$CONTAINER_REGISTRY"
: "$VERSION"
: "$REGISTRY_UN"
: "$REGISTRY_PW"
: "$NAME"
: "$DIRECTORY"

PLATFORM=${PLATFORM:-linux/amd64}

echo $REGISTRY_PW | docker login $CONTAINER_REGISTRY --username $REGISTRY_UN --password-stdin

docker buildx build --platform $PLATFORM -t $CONTAINER_REGISTRY/$NAME:$VERSION --push --file ./$DIRECTORY/Dockerfile-prod ./$DIRECTORY
