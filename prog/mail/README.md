# Mail Configuration

I manage emails using [notmuch][notmuch] and [emacs][emacs].

I have several mail accounts setup and configured using [isync](./isync). These mails
are fetched onto my personal VPS at **kisara.moe** where their indexed and tagged by
notmuch before being synced to my local machines. This means I actually have 2 mail
configurations, one for the main server and one for any machines connecting to that
server.

[notmuch]: https://notmuchmail.org/
[emacs]: ../editors/emacs

Mail itself is synced using [muchsync][muchsync] which ensures both mail files and
tags are kept up-to date with master server. This requires you to be able to SSH onto
that server without a password prompt (public key authentication) so make sure that
works before attempting any of this.

[muchsync]: http://www.muchsync.org/

Once ready on the server side you need to initialise a notmuch database, which can be
done by `muchsync -vv`. Be warned much-sync is a very old project and it's starting to
show its age. It doesn't support a XDG compliant configuration directory or mail
profiles. It also seems somewhat buggy in regard to some of its options (see
[pre-new.server](./notmuch/hooks/pre-new.server)).
Once you've setup the server you can initialise a local copy of the remote mailbox by
running `muchsync --init ~/Documents/mail kisara` (where kisara is the hostname of the
master server).
At this point I'd recommend setting up cron jobs to run `notmuch new` on both the
server and the clients. The server will fetch mail from any configured remote
accounts and the clients will fetch mail and tags from the server.
