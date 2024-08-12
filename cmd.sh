BUILD_VERSION=0.1.5
docker build \
            --build-arg JDK_VERSION=21 \
			--build-arg PYTHON_VERSION=3 \
            --build-arg TIMEZONE=Asia/Tashkent \
			--no-cache \
            -t israiloff/jvim:$BUILD_VERSION .
docker tag israiloff/jvim:$BUILD_VERSION israiloff/jvim:latest
