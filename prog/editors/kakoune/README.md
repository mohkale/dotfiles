# kakoune - mawww's experiment for a better code editor

A vi like editor that's [notoriously not vi][kak] :grin:.

[kak]: https://github.com/mawww/kakoune

## Deviations From vi

| Key      | Description                                                        |
|----------|--------------------------------------------------------------------|
| G        | remapped to ge                                                     |
| 0        | remapped to M-h                                                    |
| $        | remapped to M-l                                                    |
| ?        | remapped to M-/                                                    |
| zz,zt,zb | resuffixed to v                                                    |
| %        | select entire buffer                                               |
| M-i      | select inside something. ciw is now M-i w c                        |
| M-a      | similair to M-i but around something                               |
| ]        | select to the end of the associated motion                         |
| [        | select to the start of the associated motion                       |
| s        | filters down a multicursor selection                               |
| S        | place a new cursor at each matching point in the current selection |
| M-s      | split a selection into multiple selections at the end of each line |
| M-k      | keep all lines in a split selection that match the regex           |
| M-K      | same as M-k but exclude                                            |
| Space    | clear selections                                                   |
