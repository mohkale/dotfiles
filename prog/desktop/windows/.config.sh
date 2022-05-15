install() {
  info 'Remapping caps-lock to control'
  run-cmd reg import caps-to-ctrl.REG
}
