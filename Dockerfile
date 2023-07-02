FROM archlinux:base-devel

RUN useradd -m build && \
    pacman -Syu --noconfirm && \
    pacman -Sy --noconfirm git pacman-contrib && \
    # Allow build to run stuff as root (to install dependencies).
    echo "build ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/build

# Location of the PKGBUILD.
VOLUME ["/pkg"]
USER build
WORKDIR /home/build

# Auto-fetch GPG keys (for checking signatures).
RUN mkdir .gnupg && \
    touch .gnupg/gpg.conf && \
    echo "keyserver-options auto-key-retrieve" > .gnupg/gpg.conf && \
    # Install paru (for building AUR dependencies).
    git clone https://aur.archlinux.org/paru-bin.git && \
    cd paru-bin && \
    makepkg --log --noconfirm --syncdeps --rmdeps --install --clean

COPY build.sh /build.sh
CMD ["/bin/bash", "/build.sh"]
