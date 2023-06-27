# BBVPN Laptop Setup Guide :computer:

This README documents various steps I'd recommend you perform when migrating from one
BBVPN laptop to another. Several of these build atop the base configuration you get
from installing my dotfiles but are recommended alongside it.

For a list of common items you should check off over a migration see the following:

- [ ] SSH config, keys and known hosts.
- [ ] Browser bookmarks and search engines.
- [ ] Shell history and local config overrides.
- [ ] Windows PowerToys config.

## Windows Bootstrap

The first step should always be to run the [Windows bootstrapper][win-bootstrap].
This will setup a baseline distribution with everything you need to get up and
started including WSL, ide-magic, Docker, etc.

[win-bootstrap]: https://bbgithub.dev.bloomberg.com/Local-Development/windows-bootstrap

### Windows Bootstrap: WSL Partition Size

The default WSL partition size is way too small. Expand the available storage by
following this [guide]()

## Keybinding Overrides

If you need to update any of the existing keybindings on your install you can use
Power Toys but for some core keys like windows or alt it's sometimes ineffective. The
[Sharp Keys](https://github.com/randyrants/sharpkeys) utility is a better option
because it updates the bindings at the registry level, applying from windows boot and
across all programs and environments.

## X Display Server

Install VcXsrv. TODO: Experiment with wslg.

Then add the following to your profile to ensure your X applications can route to the
server.

```bash
export DISPLAY=$(ip route list default | awk '{print $3}'):0
```
