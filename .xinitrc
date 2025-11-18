#!/bin/sh

# Merge X resources
if [ -f "$HOME/.Xresources" ]; then
    xrdb -merge "$HOME/.Xresources"
fi

# Start i3 window manager
exec i3
