FROM archlinux:latest

ARG UID=1000
ARG GID=1000

RUN pacman -Syu --noconfirm                                   \
 && pacman -S --noconfirm base-devel git sudo                 \
 && useradd builduser -m --uid $UID                           \
 && passwd -d builduser                                       \
 && printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers

USER builduser

RUN sudo pacman -S --noconfirm                                                                                        \
      markdownlint                                                                                                    \
      python-pylint                                                                                                   \
      rubocop                                                                                                         \
      yamllint                                                                                                        \
      npm                                                                                                             \
      curl                                                                                                            \
 && sudo npm install -g jsonlint                                                                                      \
 && pushd $(mktemp -d) >/dev/null 2>&1                                                                                \
    && curl -LO https://github.com/koalaman/shellcheck/releases/download/v0.9.0/shellcheck-v0.9.0.linux.x86_64.tar.xz \
    && tar -xf shellcheck-v0.9.0.linux.x86_64.tar.xz                                                                  \
    && sudo mv ./shellcheck-v0.9.0/shellcheck /usr/bin/shellcheck                                                     \
    && rm -rf $(pwd)                                                                                                  \
    && popd

WORKDIR /workarea
