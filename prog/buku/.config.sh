install() {
  link-to "$XDG_BIN_DIR" cmds/*

  packages yay:buku
}

remove() {
  unlink-from "$XDG_BIN_DIR" cmds/*
  packages-remove yay:buku
}
