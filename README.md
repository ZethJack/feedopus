# feedopus

Checks the feeds you select and saves new uploads as Opus audio. Livestreams, upcoming streams, and archived livestreams (stream VODs) are skipped.

Works on Linux and in Termux on Android. Needs Python 3.11 or newer, yt-dlp, and ffmpeg with libopus.

## Install on Linux

Copy this directory to the machine, then:

```
./install-linux
```

That copies `feedopus` into `~/.local/bin` (overwriting any existing copy), installs Python 3.11+, ffmpeg with libopus, and yt-dlp when they are missing, writes a config if you do not have one, installs the manual, and enables the two-hour timer. It does not start the timer. Start it with `systemctl --user start feedopus.timer`.

An existing config and feed list are left in place. If `feeds_file` names a path that is not on this machine, and `~/.config/feedopus/feeds` exists, that setting is updated.

To keep the memory of episodes already heard on another computer:

```
./install-linux --state-from /path/to/old/feedopus-state
```

That directory is the other machine's `~/.local/state/feedopus`. `state.json` and `archive.txt` are copied only when this user does not already have them. `--start` starts the timer immediately.

Running `./install-linux` again replaces `~/.local/bin/feedopus`, the manual, the tldr page, and the timer unit. Config, the feed list, and remembered episodes stay as they are.

## Source package

The git tree for this machine is `~/.local/src/feedopus`. From that directory:

```
./dist
```

That writes `feedopus-VERSION.tar.gz` from the latest commit. Unpack it on another Linux machine and run `./install-linux` there. The tarball does not contain your config, feed list, or episode memory.

## Desktop

```
feedopus init          # writes ~/.config/feedopus/ and imports video feeds from newsboat
feedopus run --dry-run
feedopus               # download
feedopus install-timer # about every two hours
systemctl --user start feedopus.timer
```

Finished files go to `~/Sync/podcast`, with the video thumbnail embedded as cover art. Partial downloads stay in `~/.local/state/feedopus/tmp`, so Syncthing does not sync a half-written file.

The first time a feed is read, only items from the last `since_days` (default 2) are downloaded. Older items are remembered and left alone. After that, anything new in the feed is downloaded. `feedopus run --backfill 3` takes the three newest unsaved items from each feed.

A channel is saved from oldest to newest. Channels take turns, in the order they appear in the feed list, so the first channel does not use every download in the run.

Add a feed with one line in `~/.config/feedopus/feeds`:

```
https://www.youtube.com/feeds/videos.xml?channel_id=UCxxxx "Channel name"
https://www.youtube.com/@Channel "Channel name"
```

YouTube `feeds/videos.xml?channel_id=UCxxxx` lines are checked from that channel's uploads playlist (`UUxxxx`), because the public RSS host often returns 404 or 500. Other RSS and Atom URLs are read directly. Any other URL is a channel or playlist subscription.

`skip_was_live` controls stream archives. Set it to `false` to keep those recordings. A normal video that YouTube premiered is sometimes marked as a past livestream, and is then skipped while `skip_was_live` is true.

Finished files are named from the title alone, with spaces and punctuation written as underscores, the way Grayjay names them. A period at the end of the title is dropped so the extension is the only dot. A file already in the output folder is skipped, including a Grayjay download whose name lost its emoji and punctuation or was cut short. Two different videos that share a long opening can be treated as the same file. A title that only adds a number, such as "Title 2", is still downloaded. The same upload on YouTube and Odysee is saved once. If the download archive lists a video and the audio file is gone, that video is downloaded again. A quiet archive hit is not reported as an error.

## Android (Termux)

This is the Android build of the same program. It is not a Play Store app. Termux can run yt-dlp and ffmpeg, which is what actually fetches the audio.

```
pkg update
pkg install python ffmpeg
pip install -U yt-dlp
termux-setup-storage
```

Copy `feedopus` onto the phone and install it on `PATH`:

```
install -m 755 feedopus "$PREFIX/bin/feedopus"
```

Copy `~/.config/feedopus/` from the computer as well. `$PREFIX/bin` is Termux's normal bin directory.

If Syncthing on the phone uses the same `~/Sync/podcast` path, leave `output_dir` as it is. Otherwise set it to something under shared storage, for example `~/storage/music/podcast`.

Termux:Boot runs scripts in `~/.termux/boot/`. This one checks every two hours while Termux is running:

```sh
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
while true; do
  feedopus run
  sleep 7200
done
```

Run it on one device at a time. Two devices checking the same feeds will each download a copy if they have not synced the finished file yet.

`feedopus remove-timer` stops the Linux timer.

## Documentation

```
feedopus --help          # commands and the options for a run
man feedopus             # each setting, the files, and the first-visit rules
tldr feedopus            # short examples
```

`feedopus install-docs` copies the manual and the tldr page into your home directory. Those files live next to the `feedopus` program (`feedopus.1`, `tldr/pages/common/feedopus.md`). On fish, the same command installs a small `tldr` wrapper so `tldr -k` does not forget the page.
