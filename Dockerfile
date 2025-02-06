FROM ubuntu:noble

RUN mkdir -p /opt/android/licenses /opt/android/ndk/

RUN apt update && apt-get install --yes --no-install-recommends \
    curl \
    unzip \
    build-essential \
    ninja-build \
    cmake \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV ANDROID_NDK_VERSION="r27c"
ENV ANDROID_SDK_ROOT="/opt/android"
ENV ANDROID_NDK_ROOT="/opt/android/android-ndk-${ANDROID_NDK_VERSION}"

## Setup Android NDK
RUN TMPINSTALLER=$(mktemp --suffix=.zip ndk-XXXXX); \
    curl -sSL https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux.zip -o $TMPINSTALLER; \
    unzip $TMPINSTALLER -d ${ANDROID_SDK_ROOT}; \
    rm $TMPINSTALLER

# ## Configure CMAKE
# ENV ANDROID_CMAKE_TOOLCHAIN="${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake" \
#     CMAKE_TOOLCHAIN_FILE="${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake" \
#     ANDROID_ABI="arm64-v8a" \
#     ANDROID_PLATFORM="android-21" \
#     ANDROID_STL="c++static" \
#     ANDROID_TOOLCHAIN="clang" \
#     ANDROID_ARM_MODE="arm" \
#     CC="$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin/clang" \
#     CXX="$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin/clang++" \
#     PATH="${ANDROID_NDK_ROOT}:${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH" 

ARG CMAKE_BUILD_TYPE=Release
ENV CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}

WORKDIR /workspace
COPY ./entrypoint /
ENTRYPOINT [ "/entrypoint" ]

VOLUME [ "/opt/android/licenses" ]
VOLUME [ "/workspace" ]

RUN git config --global --add safe.directory /workspace

CMD [ "build" ]
