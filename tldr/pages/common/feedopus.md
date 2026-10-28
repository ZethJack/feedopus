# feedopus

> Save new videos from selected feeds as Opus audio.
> Livestreams and archived livestreams are skipped. The thumbnail is embedded as cover art.
> More information: <man feedopus>.

- Download new audio from the configured feeds:

`feedopus`

- Show what would be saved, without writing files:

`feedopus run --dry-run`

- Save the N newest unsaved items from each feed:

`feedopus run --backfill {{count}}`

- Only consider items from the last N days, and stop after a few downloads:

`feedopus run --since-days {{days}} --max {{count}}`

- Save one video:

`feedopus grab {{url}}`

- Write a config and import video feeds from newsboat:

`feedopus init`

- Show the selected feeds:

`feedopus list`

- Show what has already been remembered:

`feedopus status`

- Enable a timer that checks about every two hours (Linux):

`feedopus install-timer && systemctl --user start feedopus.timer`

- Install this page and the manual:

`feedopus install-docs`

- Install on Linux from a copy of the project directory:

`./install-linux`
