install() {
  link                                                        \
    "$XDG_CONFIG_HOME/gotop/gotop.conf"                       \
    mohkale.layout:"$XDG_CONFIG_HOME/gotop/layouts/mohkale"   \
    detailed.layout:"$XDG_CONFIG_HOME/gotop/layouts/detailed"

  packages                                        \
    yay:gotop-git                                 \
    go:github.com/xxxserxxx/gotop/cmd/gotop
}

remove() {
  unlink                                                      \
    "$XDG_CONFIG_HOME/gotop/gotop.conf"                       \
    mohkale.layout:"$XDG_CONFIG_HOME/gotop/layouts/mohkale"   \
    detailed.layout:"$XDG_CONFIG_HOME/gotop/layouts/detailed"

  packages-remove                                 \
    yay:gotop-git                                 \
    go:github.com/xxxserxxx/gotop/cmd/gotop
}
