install() {
  if hash choco 2>/dev/null; then
    info "Installing Chocolatey"
    run-cmds <<-"EOF"
install_script='https://chocolatey.org/install.ps1'
install_file=$(basename "$install_script")
if ! [ -f "$install_file" ]; then
  if curl -LO "$install_script"; then
    powershell -Command 'Set-ExecutionPolicy Bypass -Scope Process; . ./'"$install_file"
  fi
fi
EOF
  fi
}
