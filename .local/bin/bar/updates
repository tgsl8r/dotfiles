#!/bin/bash

case $1 in
  key-update)
		foot bash -c "sudo xbps-install -Suv"
		qtile cmd-obj -o widget checkupdates -f force_update
    ;;
  *)
		# Supress error codes to stop issues with CheckUpdates widget
		xbps-install -Mun 2> /dev/null
		exit 0
    ;;
esac
