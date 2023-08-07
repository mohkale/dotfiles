packagex wget

info "Generating WgetRC File"
run-cmds <<-'EOF'
dest="$XDG_CONFIG_HOME/wgetrc"
cp -f wgetrc "$dest"
sed -i -e 's ~ '"$HOME"' g' "$dest"
EOF
