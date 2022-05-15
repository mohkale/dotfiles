install() {
  packages                                      \
    choco:dropbox                               \
    yay:dropbox

  link -i ~/Dropbox/org/docs:"$XDG_DOCUMENTS_DIR/books"
}

remove() {
  packages-remove                               \
    choco:dropbox                               \
    yay:dropbox

  unlink ~/Dropbox/org/docs:"$XDG_DOCUMENTS_DIR/books"
}
