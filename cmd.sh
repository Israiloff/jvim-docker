BUILD_VERSION=0.4.14
JDK_VERSION=21
OS_VERSION=24.04
PYTHON_VERSION=3
TIMEZONE=Asia/Tashkent
ARCH_ARM64=arm64
ARCH_AMD64=amd64

docker buildx build --platform linux/$ARCH_ARM64 \
            --build-arg JDK_VERSION=$JDK_VERSION \
            --build-arg OS_VERSION=$OS_VERSION \
			--build-arg PYTHON_VERSION=$PYTHON_VERSION \
            --build-arg TIMEZONE=$TIMEZONE \
            --build-arg ARCH=$ARCH_ARM64 \
            -t israiloff/jvim:$BUILD_VERSION-$ARCH_ARM64 .
docker tag israiloff/jvim:$BUILD_VERSION-$ARCH_ARM64 israiloff/jvim:latest-$ARCH_ARM64

docker buildx build --platform linux/$ARCH_AMD64 \
            --build-arg JDK_VERSION=$JDK_VERSION \
            --build-arg OS_VERSION=$OS_VERSION \
            --build-arg PYTHON_VERSION=$PYTHON_VERSION \
            --build-arg TIMEZONE=$TIMEZONE \
            --build-arg ARCH=$ARCH_AMD64 \
            -t israiloff/jvim:$BUILD_VERSION-$ARCH_AMD64 .
docker tag israiloff/jvim:$BUILD_VERSION-$ARCH_AMD64 israiloff/jvim:latest-$ARCH_AMD64 israiloff/jvim:latest

docker push israiloff/jvim:$BUILD_VERSION-$ARCH_ARM64
docker push israiloff/jvim:latest-$ARCH_ARM64
docker push israiloff/jvim:$BUILD_VERSION-$ARCH_AMD64
docker push israiloff/jvim:latest-$ARCH_AMD64
