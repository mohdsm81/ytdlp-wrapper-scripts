#!/usr/bin/env bash

# download all playlists in the channel
./download-list "$@"

# re-organize files (creating a folder per playlist and moving files into their
# respective folder/playlist)
./do.organize.sh
