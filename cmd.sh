BUILD_VERSION=0.4.14
JDK_VERSION=21
OS_VERSION=24.04
PYTHON_VERSION=3
TIMEZONE=Asia/Tashkent

docker buildx create --name multiarch --use 2>/dev/null || docker buildx use multiarch
docker buildx inspect --bootstrap

docker buildx build \
  --platform linux/arm64,linux/amd64 \
  --build-arg JDK_VERSION=$JDK_VERSION \
  --build-arg OS_VERSION=$OS_VERSION \
  --build-arg PYTHON_VERSION=$PYTHON_VERSION \
  --build-arg TIMEZONE=$TIMEZONE \
  -t israiloff/jvim:$BUILD_VERSION \
  -t israiloff/jvim:latest \
  --push \
  .
