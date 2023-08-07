packagex polybar

link                                            \
  "$XDG_CONFIG_HOME/polybar/config"             \
  "$XDG_CONFIG_HOME/polybar/colors"
link-to "$XDG_CONFIG_HOME/polybar/cmds/" ./cmds/*
link-to "$XDG_CONFIG_HOME/polybar/bars/" ./bars/*
link-to "$XDG_CONFIG_HOME/polybar/modules/" ./modules/*

if ! [ -e "$XDG_CONFIG_HOME/polybar/bars/default" ]; then
  info "Generating default polybar configuration"

  run-cmds <<-'EOF'
sed -e 's bar/example bar/default ' "$XDG_CONFIG_HOME/polybar/bars/example" > "$XDG_CONFIG_HOME/polybar/bars/default"
EOF
fi
