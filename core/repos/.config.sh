#!/usr/bin/env bash
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
