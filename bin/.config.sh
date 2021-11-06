clean -rf "$XDG_BIN_DIR"

link \
  "$XDG_BIN_DIR/ansils"                         \
  "$XDG_BIN_DIR/argv"                           \
  "$XDG_BIN_DIR/blockify"                       \
  "$XDG_BIN_DIR/broken-links"                   \
  "$XDG_BIN_DIR/build-aliases"                  \
  "$XDG_BIN_DIR/bulkchmod"                      \
  "$XDG_BIN_DIR/bulkrename"                     \
  "$XDG_BIN_DIR/check-font"                     \
  "$XDG_BIN_DIR/chunk"                          \
  "$XDG_BIN_DIR/clip"                           \
  "$XDG_BIN_DIR/clipsink"                       \
  "$XDG_BIN_DIR/condemn"                        \
  "$XDG_BIN_DIR/count-updates"                  \
  "$XDG_BIN_DIR/cron-retry"                     \
  "$XDG_BIN_DIR/dotsync"                        \
  "$XDG_BIN_DIR/env-paths"                      \
  "$XDG_BIN_DIR/evi"                            \
  "$XDG_BIN_DIR/extract"                        \
  "$XDG_BIN_DIR/fdupes"                         \
  "$XDG_BIN_DIR/file-path"                      \
  "$XDG_BIN_DIR/filter-globs"                   \
  "$XDG_BIN_DIR/git-fzlog"                      \
  "$XDG_BIN_DIR/git-prompt"                     \
  "$XDG_BIN_DIR/group-seq"                      \
  "$XDG_BIN_DIR/ignore-exit"                    \
  "$XDG_BIN_DIR/image2ascii"                    \
  "$XDG_BIN_DIR/img2pdf"                        \
  "$XDG_BIN_DIR/invert"                         \
  "$XDG_BIN_DIR/launch"                         \
  "$XDG_BIN_DIR/ls-aliases"                     \
  "$XDG_BIN_DIR/ls-arch"                        \
  "$XDG_BIN_DIR/ls-bookmarks"                   \
  "$XDG_BIN_DIR/ls-distro"                      \
  "$XDG_BIN_DIR/ls-exec"                        \
  "$XDG_BIN_DIR/ls-fsmaps"                      \
  "$XDG_BIN_DIR/ls-games"                       \
  "$XDG_BIN_DIR/ls-mount"                       \
  "$XDG_BIN_DIR/ls-platform"                    \
  "$XDG_BIN_DIR/ls-projects"                    \
  "$XDG_BIN_DIR/magnet2torrent"                 \
  "$XDG_BIN_DIR/moji"                           \
  "$XDG_BIN_DIR/preview"                        \
  "$XDG_BIN_DIR/prog-icons"                     \
  "$XDG_BIN_DIR/project-files"                  \
  "$XDG_BIN_DIR/project-root"                   \
  "$XDG_BIN_DIR/pschain"                        \
  "$XDG_BIN_DIR/show-banners"                   \
  "$XDG_BIN_DIR/spawn-term"                     \
  "$XDG_BIN_DIR/tctl"                           \
  "$XDG_BIN_DIR/tmux-popup"                     \
  "$XDG_BIN_DIR/vipe"                           \
  "$XDG_BIN_DIR/xopen"

if bots xorg; then
  link "$XDG_BIN_DIR/app-windows"               \
       "$XDG_BIN_DIR/term-dwim"
fi

import lib
