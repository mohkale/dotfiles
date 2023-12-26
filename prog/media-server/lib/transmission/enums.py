import enum


class TransmissionTorrentStatus(enum.IntEnum):
    """
    Possible values for the status field in the torrent-get request.

    See the [[https://github.com/transmission/transmission/blob/master/libtransmission/transmission.h#L1652][tr_torrent_activity]]
    enumeration in the transmission src.
    """

    stopped = 0
    check_wait = 1
    check = 2
    download_wait = 3
    download = 4
    seed_wait = 5
    seed = 6
