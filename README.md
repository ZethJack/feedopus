# feedopus

Save new videos from the feeds you select as Opus audio. Livestreams, upcoming streams, and archived livestreams are skipped. The thumbnail is stored as cover art inside the file.

Linux and Termux. Requires Python 3.11 or newer, yt-dlp, and ffmpeg with libopus.

## Install

From a clone or an unpacked source tarball:

```
./install-linux
systemctl --user start feedopus.timer
```

`./install-linux` copies the program to `~/.local/bin/feedopus`, installs any missing dependencies, writes a config if you have none, installs the manual, and enables a timer that runs about every two hours. It does not start the timer. Running it again replaces the program, the manual, and the timer unit. Config, the feed list, and remembered episodes stay in place.

`./dist` builds `feedopus-VERSION.tar.gz` from the latest commit. The archive does not contain a config, a feed list, or episode memory.

To copy episode memory from another machine, pass that machine's `~/.local/state/feedopus`:

```
./install-linux --state-from /path/to/old/state
```

## Use

```
feedopus init
feedopus run --dry-run
feedopus
feedopus clean --dry-run
```

`feedopus init` writes `~/.config/feedopus/` and imports video feeds from newsboat. Finished audio goes to `~/Sync/podcast`.

A feed line:

```
https://www.youtube.com/feeds/videos.xml?channel_id=UCxxxx "Channel name"
https://www.youtube.com/@Channel "Channel name"
```

YouTube RSS is tried first. If that request fails, the channel's uploads playlist is checked. Other RSS and Atom feeds are read directly. Any other URL is a channel or playlist.

The first visit to a feed takes items from the last two days and remembers the rest. Later runs take anything new. `feedopus run --backfill 3` takes the three newest unsaved items from each feed. Within a channel, files are saved oldest first, and channels take turns.

Files are named from the title, with spaces and punctuation written as underscores, so a Grayjay download of the same video is recognized. A file already in the folder is skipped. Deleting a file does not forget the episode.

`feedopus clean` deletes the oldest audio files and leaves the 30 newest. `--keep N` or `keep_episodes` in the config changes that number. `--dry-run` lists the files and deletes nothing.

Run it on one device at a time. Two devices that have not synced a finished file will each download a copy.

## Android

Use Termux from F-Droid. This is not a Play Store app.

```
pkg install python ffmpeg
pip install -U yt-dlp
termux-setup-storage
install -m 755 feedopus "$PREFIX/bin/feedopus"
```

Copy `~/.config/feedopus/` from the computer. If the phone's Syncthing folder is not `~/Sync/podcast`, set `output_dir` to that folder. Leave the two-hour loop below off while the Linux timer is enabled.

```sh
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
while true; do
  feedopus run
  sleep 7200
done
```

## Documentation

```
feedopus --help
man feedopus
tldr feedopus
```

`feedopus install-docs` installs the manual and the tldr page for the current user.
