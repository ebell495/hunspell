# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install build-essential autoconf automake autopoint libtool libiconv-hook1 gettext -y

## Add source code to the build stage.
ADD . /hunspell
WORKDIR /hunspell

## Build hunspell.
ENV CC gcc
ENV CXX g++
RUN autoreconf -vfi
RUN ./configure
RUN make
RUN make install
RUN ldconfig

# Add hunspell dictionary to the root directory.
RUN DEBIAN_FRONTEND=noninteractive apt-get install wget -y
WORKDIR /
RUN wget -O en_US.aff  https://cgit.freedesktop.org/libreoffice/dictionaries/plain/en/en_US.aff?id=a4473e06b56bfe35187e302754f6baaa8d75e54f
RUN wget -O en_US.dic https://cgit.freedesktop.org/libreoffice/dictionaries/plain/en/en_US.dic?id=a4473e06b56bfe35187e302754f6baaa8d75e54f

# # Package Stage
# FROM --platform=linux/amd64 ubuntu:20.04
# RUN apt-get update && \
#     DEBIAN_FRONTEND=noninteractive apt-get install libiconv-hook1 gettext -y


# # ## TODO: Change <Path in Builder Stage>
# COPY --from=builder /usr/local/bin/hunspell /
# COPY --from=builder /en_US.aff /
# COPY --from=builder /en_US.dic /