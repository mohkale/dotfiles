install() {
  link-to "$XDG_BIN_DIR" cmds/*

  package yay ffmpeg
  package pip ffpb
}

remove() {
  unlink-from "$XDG_BIN_DIR" cmds/*

  package-remove yay ffmpeg
  package-remove pip ffpb
}
