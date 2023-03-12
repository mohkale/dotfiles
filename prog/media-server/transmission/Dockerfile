ARG LINUXSERVER_IMAGE_VERSION=version-3.00-r6
FROM lscr.io/linuxserver/transmission:${LINUXSERVER_IMAGE_VERSION}

COPY scripts/transmission/requirements.txt /tmp/requirements.txt
RUN apk add --update-cache py-pip libnotify         \
 && python3 -m pip install -r /tmp/requirements.txt \
 && rm -f /tmp/requirements.txt                     \
 && rm -rf /var/cache/apk

ENV PYTHONPATH="${PYTHONPATH}:/scripts"
