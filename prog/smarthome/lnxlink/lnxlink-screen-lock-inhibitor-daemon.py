#!/usr/bin/env python3
import dbus
import sys
import logging
from time import sleep

logging.basicConfig(level=logging.DEBUG, stream=sys.stderr)

bus = dbus.SessionBus()
while True:
    try:
        remote_object = bus.get_object('org.freedesktop.PowerManagement.Inhibit', '/org/freedesktop/PowerManagement/Inhibit')
    except dbus.exceptions.DBusException:
        logging.exception("Failed to open target bus, retrying in 5 seconds")
        sleep(5)
    else:
        break

response = remote_object.Inhibit('lnxlink', 'Through HomeAssistant', dbus_interface='org.freedesktop.PowerManagement.Inhibit')
logging.info('cookie is %s', response)

# This process must be kept alive or as soon as it exits the screen lock will be cancelled.
try:
    while True:
        sleep(1000000)
except KeyboardInterrupt:
    logging.info('KeyboardInterrupt, exiting...')
