link ~/.gemrc                                   \
     "$XDG_CONFIG_HOME/irb/irbrc"               \
     "$XDG_CONFIG_HOME/pry/pryrc"

if package apt; then
  package apt ruby-full
elif package choco; then
  package choco ruby
  # setup the ruby installer developement kit (ridk).
  # literally the only thing making ruby development on
  # windows not maddening.
  run-cmd c:/tools/ruby27/bin/ridk.ps1 install 2 3
elif package yay; then
  package choco rbenv
  # Install my preferred ruby version automatically
  run-cmd rbenv install -s --verbose 2.6.6
fi

packages gem:colorize,rake,pry,pry-doc
