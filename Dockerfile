FROM debian:stretch as builder

ENV RISCV_VERSION master

LABEL \
      com.github.lerwys.docker.dockerfile="Dockerfile" \
      com.github.lerwys.vcs-type="Git" \
      com.github.lerwys.vcs-url="https://github.com/lerwys/docker-riscv-tools.git"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get install -y \
        automake \
        autoconf \
        build-essential \
        gawk \
        curl  \
        bison \
        flex \
        texinfo \
        libmpc-dev \
        libmpfr-dev \
        libgmp-dev \
        libtool \
        libz-dev \
        libexpat1-dev \
        git && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --recurse-submodules https://github.com/riscv/riscv-gnu-toolchain && \
    cd riscv-gnu-toolchain && \
    mkdir /opt/riscv32im && \
    ./configure --prefix=/opt/riscv32im --with-arch=rv32im && \
    make && \
    make install && \
    cd / && \
    rm -rf riscv-gnu-toolchain

FROM debian:stretch

COPY --from=builder /opt/riscv32im /opt/riscv32im

ENV PATH "/opt/riscv32i/bin:$PATH"
VOLUME /opt/riscv32im
