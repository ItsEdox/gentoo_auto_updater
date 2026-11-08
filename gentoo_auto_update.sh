#!/bin/bash

if [ $(id -u) != "0" ]; then
    echo "ERROR: You need to be root!"
    exit
fi

TITLE="Gentoo Auto Updater"
echo -en '\033]2;'$TITLE'\007'

echo -e "\nUPDATER INFO: GENTOO AUTO UPDATER by Edox\n" > latest.auto_log
echo -e "\nUPDATER INFO: STARTING SYNC\n" >> latest.auto_log
echo -en '\033]2;'$TITLE': Syncing\007'

SYNC_OUTPUT="$(EMERGE_DEFAULT_OPTS="" emaint --auto sync | awk '/Action: sync for repo/ {print}')"
echo $SYNC_OUTPUT >> latest.auto_log
SYNC_FAILURE=0
while IFS= read -r line; do
    OUTPUT_CHAR="$(echo $line | tail -c 2)"
    if [ "$OUTPUT_CHAR" != "0" ]; then
	SYNC_FAILURE=1
	break
    fi
done <<< $SYNC_OUTPUT
if [ $SYNC_FAILURE -ne 0 ]; then
    echo 'ERROR: Failed to sync repos!' >> latest.auto_log
    exit
fi

echo -e "\nUPDATER INFO: STARTING EMERGE\n" >> latest.auto_log
echo -en '\033]2;'$TITLE': Upgrading/Compiling\007'

tail -n 0 -f /var/log/emerge.log >> latest.auto_log &
TAIL_PROCESS=$!
EMERGE_DEFAULT_OPTS="" emerge --update --deep --quiet --newuse --with-bdeps=y @world
EMERGE_EXIT_CODE=$?
kill $TAIL_PROCESS
if [ $EMERGE_EXIT_CODE -ne 0 ]; then
    echo 'ERROR: Packages failed to upgrade! Manual upgrading required!' >> latest.auto_log
    exit
fi

CONFIG_WARNING=0

if dispatch-conf | grep "zap"; then
	echo 'INPORTANT: There are some files that need configuring!' >> latest.auto_log
	CONFIG_WARNING=1
fi

echo -en '\033]2;'$TITLE': Finished\007'
exit
