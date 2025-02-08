FROM ubuntu:noble


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
RUN mkdir -p /opt/android/licenses; \
    TMPINSTALLER=$(mktemp --suffix=.zip ndk-XXXXX); \
    curl -sSL https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux.zip -o $TMPINSTALLER; \
    unzip $TMPINSTALLER -d ${ANDROID_SDK_ROOT}; \
    rm $TMPINSTALLER


ARG BUILD_USER_ID
ARG CONTEXT=local
ENV CONTEXT=${CONTEXT}
ARG VERSION=development
ENV VERSION=${VERSION}

RUN <<EOF
set -eu
mkdir -p /source /dist /build
chown -R ubuntu:ubuntu /build /dist
git config --global --add safe.directory /source
EOF

WORKDIR /build
COPY entrypoint /usr/local/bin/start
ENTRYPOINT [ "/usr/local/bin/start" ]


VOLUME [ "/opt/android/licenses" ]
VOLUME [ "/source" ]
VOLUME [ "/dist" ]

USER ubuntu
CMD [ "release" ]
