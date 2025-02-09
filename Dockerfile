FROM debian:bookworm-slim

## Install base packages
RUN <<EOF
set -eu
apt-get update
apt-get install --yes --no-install-recommends \
    ca-certificates \
    build-essential \
    cmake \
    curl \
    ninja-build \
    unzip
rm -rf /var/lib/apt/lists/*
EOF

## Setup non-root builder user
ARG builder_uid=1000
RUN <<EOF
set -eu
if getent passwd ${builder_uid}; then
    groupmod ubuntu --new-name builder
    usermod ubuntu --login genie --home /build --move-home --shell /bin/bash --comment "genius"
else
    groupadd builder
    useradd genie --uid ${builder_uid} --gid builder --home-dir /build --create-home --shell /bin/bash --comment "genius"
fi
mkdir -p /source /dist
chown -R genie /source /dist
EOF

## Setup Android NDK
ENV ANDROID_NDK_VERSION="r27c"
ENV ANDROID_SDK_ROOT="/opt/android"
ENV ANDROID_NDK_ROOT="/opt/android/android-ndk-${ANDROID_NDK_VERSION}"
RUN <<EOF
set -eu
mkdir -p /opt/android/licenses 
TMPINSTALLER=$(mktemp --suffix=.zip ndk-XXXXX)
curl -sSL https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux.zip -o $TMPINSTALLER
unzip $TMPINSTALLER -d ${ANDROID_SDK_ROOT}
rm $TMPINSTALLER
EOF

## Add context awareness
ARG context=local
ENV CONTEXT=${context}
ARG version=development
ENV VERSION=${version}

## Build area
WORKDIR /build
COPY entrypoint /usr/local/bin/start
ENTRYPOINT [ "/usr/local/bin/start" ]

VOLUME [ "/opt/android/licenses" ]
VOLUME [ "/source" ]
VOLUME [ "/dist" ]

USER genie
CMD [ "release" ]
