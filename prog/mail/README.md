# Mail Configuration

I manage emails using [notmuch][notmuch] in my [emacs][emacs] config.
Mails itself are contained in several accounts, some gmail and some on my
personal server. I use [isync](https://wiki.archlinux.org/title/isync) to fetch and
push mail data from my various accounts to my localhost (where I can manage them
through **notmuch**).

[notmuch]: https://notmuchmail.org/
[emacs]: ../editors/emacs

Before you hackers start getting some *funny* ideas, I don't keep plaintext passwords
in my isync config. Their kept in a GPG encrypted in password store and decrypted on
fetch through isync.
