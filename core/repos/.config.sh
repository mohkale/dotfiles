#!/usr/bin/env bash
sync-submodule ./walls
if is-unix; then
  # I prefer to keep wallpapers in XDG_PICTURES_DIR so if linux
  # expects them somewhere else we can just link through to them.
  link -i "$XDG_PICTURES_DIR/wallpapers:$XDG_DATA_HOME/wallpapers"
fi
link-to "$XDG_PICTURES_DIR/wallpapers" ./walls/*.{png,jpg,jpeg,gif}

for it in "org:$DOTFILES_ORG_REPO" "pass:$PASSWORD_STORE_REPO"; do
  IFS=: read -r dir repo <<< "$it"
  if [ -n "$repo" ]; then
    if [ -d "$dir" ]; then
      import "$dir"
    else
      # When first setup we won't have cloned the target repository yet
      # so importing it will do nothing. To work properly we need to
      # rerun manage to run installation steps lazily.
      run-cmd git clone "$repo" "$(pwd)/$dir"
      manage "$(pwd)/$dir"
    fi
  fi
done
