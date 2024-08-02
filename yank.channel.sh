#!/usr/bin/env bash

# download all playlists in the channel
/usr/local/bin/download-list "$@"

# re-organize files (creating a folder per playlist and moving files into their
# respective folder/playlist)
/usr/local/bin/do.organize.sh
