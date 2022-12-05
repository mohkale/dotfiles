# Steam

A video game management platform and sort-of DRM implementation for PC gaming.

> The easiest way to stop piracy is not by putting antipiracy technology to work.
> It's by giving those people a service that's better than what they're receiving
> from the pirates. - Gabe Newell

## Hall of Shame

### 2K Launcher

In September 2022 2K gaming added the new 2K launcher as a quality of life
improvement to several older games in their catalogue including the BioShock
collection. It's too late now to properly request a refund in my case, but you can
bypass this invasive launcher by setting the launch options of each of these games to
simply run the game directly, instead of deferring to the launcher. The launcher is
quite literally a forced redirection, and as of 2022-09-28 the game files have not
been modified to fail if the launcher is not used.

```bash
# Bioshock 1
bash -c 'exec "${@/2KLauncher\/LauncherPatcher.exe/Build\/Final\/BioshockHD.exe}"' -- %command% -nointro

# Bioshock 2
bash -c 'exec "${@/2KLauncher\/LauncherPatcher.exe/Build\/Final\/Bioshock2HD.exe}"' -- %command% -nointro

# Bioshock Infinite
bash -c 'exec "${@/2KLauncher\/LauncherPatcher.exe/Binaries\/Win32\/BioShockInfinite.exe}"' -- %command%
```

### Ubisoft Dead DLC

Ubisoft [announced][2022-ubisoft-online-decom] on 2022-09-01 that a month later on
2022-10-01 that online services for some older Ubisoft games will be decomissioned.
Beyond the obvious removal of multiplayer support for these games going away, since
the server implementation is closed source and no-one can bring up a compatible
alternative, Ubisoft also intends to shut down the verification services for DLC in
some of these older games as well. This means if you've purchased these games and
haven't installed and activated them through uPlay/Ubisoft-Connect prior to the
decommision date then you've essentially lost access to these games DLCs forever.
Similarly you will no longer be able to purchase this DLC after the decomission date,
with those wanting to being directed to purchasing later remakes or remasters.
This all comes after a previous attempt from Ubisoft to make already purchased games
[unplayable][2022-ubisoft-steal-dlc].

[2022-ubisoft-online-decom]: https://www.ubisoft.com/en-gb/help/gameplay/article/decommissioning-of-online-services-for-older-ubisoft-games-october-2022-update/000102396
[2022-ubisoft-steal-dlc]: https://www.youtube.com/watch?v=tsDM_MLf7hU
