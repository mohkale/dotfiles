packagex brave

# There's no automated way to install unofficial chrome extensions, so if
# you want the start-page you're going to have to open brave://extensions,
# enable developer mode, load-unpacked, then navigate to ./startpage and
# load it.
sync-submodule startpage
link -f startpage.json:startpage/config.json
