# LibreWolf

A privacy-concious internet [browser][librewolf] derived from Firefox.

[librewolf]: https://librewolf.net/
[firefox]: https://www.mozilla.org/en-US/firefox/new/

I'd recommend the following extensions to be setup after installation:

+ [Allow Right-Click](https://addons.mozilla.org/en-US/firefox/addon/re-enable-right-click/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
+ [Augmented Steam](https://addons.mozilla.org/en-US/firefox/addon/augmented-steam/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
+ [Auto Tab Discard](https://addons.mozilla.org/en-US/firefox/addon/auto-tab-discard/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
+ [Better Inventory for Displate](https://addons.mozilla.org/en-US/firefox/addon/better-inventory-for-displate/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
+ [Canvas Blocker](https://addons.mozilla.org/en-US/firefox/addon/canvasblocker/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
+ [Consent-O-Matic](https://addons.mozilla.org/en-US/firefox/addon/consent-o-matic/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
+ [cookies.txt](https://addons.mozilla.org/en-US/firefox/addon/cookies-txt/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
+ [Dark Reader](https://addons.mozilla.org/en-US/firefox/addon/darkreader/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
+ [Firefox Multi-Account Containers](https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
+ [Markdown Viewer](https://addons.mozilla.org/en-US/firefox/addon/markdown-viewer-chrome/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
+ [Plasma Integration](https://addons.mozilla.org/en-US/firefox/addon/plasma-integration/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)
  (if running on KDE Plasma)
  + Note: plasma integration depends on a [native messaging host][kde-nmh] for the
    desktop environment. This is setup for firefox on install but not librewolf. For
    now you can work around this by copying the browser integration config to the
    right directory.

    ```bash
    mkdir -p ~/.librewolf/native-messaging-hosts
    ln -sv /usr/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json ~/.librewolf/native-messaging-hosts/
    ```

    [kde-nmh]: https://gitlab.com/librewolf-community/browser/linux/-/issues/242

+ [Privacy Badger](https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)

## uBlock Origin Filters

+ [uBlock Origin dev filter](https://github.com/quenhus/uBlock-Origin-dev-filter)
+ [LegitimateURLShortener](https://subscribe.adblockplus.org/?location=https://gitlab.com/DandelionSprout/adfilt/-/raw/master/LegitimateURLShortener.txt&title=DandelionSprout-URL-Shortener)
