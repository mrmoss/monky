# Overview
This is a terrible ripoff of conky for macOS.

I got conky to compile for macOS...but it uses XQuartz...but transparecy doesn't work...only shows up on one desktop...etc...

This only supports text.

# Usage

Usage: `./monky [int INTERVAL_IN_SECONDS] [str COMMAND]`

Example 1 (shows the date every 2 seconds): `./monky 2 date`

Example 2 (shows the first 5 processes from ps every 2 seconds): `./monky 2 'ps -ef|head -n 6'`

# Building

There are no dependencies other than macOS and and the cocoa framework...

`make`

# Bugs

- I have NO IDEA how memory mangement works with objective-c...so possible memory leaks?

# Screenshots

Note: The script I'm running is a custom viewing script...you'll have to make your own T_T

![](https://github.com/mrmoss/monky/raw/master/screenshots/overview.png)
![](https://github.com/mrmoss/monky/raw/master/screenshots/zoomed_in.png)
