#!/bin/sh
# Newsboat bookmark script
# Arguments: $1=URL $2=title $3=description $4=feed_title

url="$1"
title="$2"
description="$3"
feed_title="$4"

bookmark_file="$HOME/.newsboat/bookmarks.txt"

echo "$(date '+%Y-%m-%d %H:%M:%S') | $title | $url | $feed_title" >> "$bookmark_file"

echo "Bookmark saved!"
