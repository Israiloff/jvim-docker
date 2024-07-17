BUILD_VERSION=0.0.1
docker build \
            --build-arg JDK_VERSION=21 \
            --build-arg TIMEZONE=Asia/Tashkent \
            -t israiloff/jvim:$BUILD_VERSION .
docker tag israiloff/jvim:$BUILD_VERSION israiloff/jvim:latest
