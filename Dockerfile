FROM ubuntu:19.04

# inspiration from https://github.com/utensils/docker-opengl/

# avoid questions from debconf
ENV DEBIAN_FRONTEND noninteractive

# install and remove packages in one layer
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
    wget \
    bzip2 \
    curl \
    git \
    sudo \
    vim \
    python \
    llvm-6.0-dev \
    zlib1g-dev \
    xserver-xorg-dev \
    build-essential \
    python3-dev \
    libxcb-dri2-0-dev \
    libxcb-xfixes0-dev \
    libxext-dev \
    libx11-xcb-dev \
    pkg-config && \
    update-alternatives --install \
        /usr/bin/llvm-config       llvm-config      /usr/bin/llvm-config-6.0  200 \
--slave /usr/bin/llvm-ar           llvm-ar          /usr/bin/llvm-ar-6.0 \
--slave /usr/bin/llvm-as           llvm-as          /usr/bin/llvm-as-6.0 \
--slave /usr/bin/llvm-bcanalyzer   llvm-bcanalyzer  /usr/bin/llvm-bcanalyzer-6.0 \
--slave /usr/bin/llvm-cov          llvm-cov         /usr/bin/llvm-cov-6.0 \
--slave /usr/bin/llvm-diff         llvm-diff        /usr/bin/llvm-diff-6.0 \
--slave /usr/bin/llvm-dis          llvm-dis         /usr/bin/llvm-dis-6.0 \
--slave /usr/bin/llvm-dwarfdump    llvm-dwarfdump   /usr/bin/llvm-dwarfdump-6.0 \
--slave /usr/bin/llvm-extract      llvm-extract     /usr/bin/llvm-extract-6.0 \
--slave /usr/bin/llvm-link         llvm-link        /usr/bin/llvm-link-6.0 \
--slave /usr/bin/llvm-mc           llvm-mc          /usr/bin/llvm-mc-6.0 \
--slave /usr/bin/llvm-mcmarkup     llvm-mcmarkup    /usr/bin/llvm-mcmarkup-6.0 \
--slave /usr/bin/llvm-nm           llvm-nm          /usr/bin/llvm-nm-6.0 \
--slave /usr/bin/llvm-objdump      llvm-objdump     /usr/bin/llvm-objdump-6.0 \
--slave /usr/bin/llvm-ranlib       llvm-ranlib      /usr/bin/llvm-ranlib-6.0 \
--slave /usr/bin/llvm-readobj      llvm-readobj     /usr/bin/llvm-readobj-6.0 \
--slave /usr/bin/llvm-rtdyld       llvm-rtdyld      /usr/bin/llvm-rtdyld-6.0 \
--slave /usr/bin/llvm-size         llvm-size        /usr/bin/llvm-size-6.0 \
--slave /usr/bin/llvm-stress       llvm-stress      /usr/bin/llvm-stress-6.0 \
--slave /usr/bin/llvm-symbolizer   llvm-symbolizer  /usr/bin/llvm-symbolizer-6.0 \
--slave /usr/bin/llvm-tblgen       llvm-tblgen      /usr/bin/llvm-tblgen-6.0 && \
    set -xe; \
    mkdir -p /var/tmp/build; \
    cd /var/tmp/build; \
    wget -q --no-check-certificate "https://mesa.freedesktop.org/archive/mesa-18.0.1.tar.gz"; \
    tar xf mesa-18.0.1.tar.gz; \
    rm mesa-18.0.1.tar.gz; \
    cd mesa-18.0.1; \
    ./configure --enable-glx=gallium-xlib --with-gallium-drivers=swrast,swr --disable-dri --disable-gbm --disable-egl --enable-gallium-osmesa --enable-llvm --prefix=/usr/local; \
    make -j4; \
    make install; \
    cd .. ; \
    rm -rf mesa-18.0.1; \
    apt-get -y remove --purge llvm-6.0-dev \
            build-essential \
            zlib1g-dev \
            xserver-xorg-dev \
            python3-dev \
            python \
            pkg-config \
            libxext-dev \
            libx11-xcb-dev \
            libxcb-xfixes0-dev \
            libxcb-dri2-0-dev && \
    apt autoremove -y --purge && sudo apt clean

# Setup our environment variables.
ENV XVFB_WHD="1920x1080x24"\
    LIBGL_ALWAYS_SOFTWARE="1" \
    GALLIUM_DRIVER="llvmpipe" \
    LP_NO_RAST="false" \
    LP_DEBUG="" \
    LP_PERF="" \
    LP_NUM_THREADS=""
