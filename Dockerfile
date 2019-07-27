FROM ubuntu:16.04

MAINTAINER Ben Baron <ben@einsteinx2.com>

# Use the bash shell instead of sh for the build process
SHELL ["/bin/bash", "-c"]

RUN apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    make build-essential wget sed git vim xz-utils libxml2 \
\
    # Install devkitPro pacman
    && wget https://github.com/devkitPro/pacman/releases/download/devkitpro-pacman-1.0.1/devkitpro-pacman.deb -O /tmp/devkitpro-pacman.deb \
    && dpkg -i /tmp/devkitpro-pacman.deb \
    && rm /tmp/devkitpro-pacman.deb \
    && echo 'export PATH="/opt/devkitpro/pacman/bin:$PATH"' >> ~/.bashrc \
\
    # Install the dev tools for all supported platforms
    && /opt/devkitpro/pacman/bin/pacman -S --noconfirm gba-dev gp32-dev nds-dev 3ds-dev gamecube-dev wii-dev wiiu-dev switch-dev \
    # Install Switch libraries needed to build examples (the examples for all other platforms build fine without extra packages)
    # NOTE: hwopus-decoder is the only example that fails to build, but it looks like a bug in the switch-libopus package
    && /opt/devkitpro/pacman/bin/pacman -S --noconfirm switch-mesa switch-glad switch-glm switch-sdl2 switch-freetype switch-opusfile switch-libopus switch-sdl2_mixer \
    && echo '. /etc/profile.d/devkit-env.sh' >> ~/.bashrc

WORKDIR /src
CMD ["/bin/bash"]
