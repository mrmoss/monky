# Overview
This is a terrible ripoff of conky for macOS.

I got conky to compile for macOS...but it uses XQuartz...and transparecy doesn't work...and it only shows up on one desktop...etc...

This only supports text (no bars or fancy graphics...not yet anyways...).

# Usage

Usage: `./monky [int INTERVAL_IN_SECONDS] [str COMMAND]`

Example 1 (shows the date every 2 seconds): `./monky 2 date`

Example 2 (shows the first 5 processes from ps every 2 seconds): `./monky 2 'ps -ef|head -n 6'`

# Building

There are no dependencies other than macOS and and the cocoa framework...

`make`

# Screenshots

Note: The script I'm running is a custom viewing script...you'll have to make your own T_T

![](https://github.com/mrmoss/monky/raw/master/screenshots/overview.png)
![](https://github.com/mrmoss/monky/raw/master/screenshots/zoomed_in.png)

# Known Issues

Seems to freeze up after 10+ hours of use...no idea why...it doesn't appear to be leaking memory...
