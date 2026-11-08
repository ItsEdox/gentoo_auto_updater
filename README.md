# Gentoo Auto Updater
An automatic update script for Gentoo Linux systems.

## How to use?

Clone this repo and run `sudo make install` to install the basic version of the script to `/usr/local/bin`

Then you will have to setup:
* A cron job if your init system is OpenRC
* A systemd service and timer if your running systemd

## How to add additional features?

Additional features such as webhook support and more can be patched in by running `make feature` to see available patches and choosing by `make feature-<OPTION>`

Some of the features included in the patch folder are:

* HTML file generation
* Discord webhook support

## How to uninstall?

Simply run `sudo make uninstall` and delete your cron job or systemd timer/service
