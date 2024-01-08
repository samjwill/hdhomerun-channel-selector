#!/bin/bash

# Determine config path
if [ -z "$XDG_CONFIG_HOME" ]; then
    XDG_CONFIG_HOME="$HOME/.config"
fi

CONFIG_DIRECTORY=$XDG_CONFIG_HOME/mpv-channel-selector
if [ ! -d "$DIRECTORY" ]; then 
    mkdir -p "$CONFIG_DIRECTORY"
fi

CHANNEL_LIST_PATH="$CONFIG_DIRECTORY/channel-list"

# Create config file if it doesn't exist
if [ ! -f "$CHANNEL_LIST_PATH" ]; then
    touch "$CHANNEL_LIST_PATH"
fi

HDHOMERUN_IP_PATH="$CONFIG_DIRECTORY/hdhomerun-ip"
if [ -f "$HDHOMERUN_IP_PATH" ]; then
    read -r HD_HOMERUN_IP < "$HDHOMERUN_IP_PATH"
fi
if [ -z "${HD_HOMERUN_IP}" ]; then
    echo -n "Enter the IP address of the HDHomeRun: "
    read HD_HOMERUN_IP
    echo "${HD_HOMERUN_IP}" >> $HDHOMERUN_IP_PATH
fi

# Define an array to store the COMMANDS
COMMANDS=()

option_number=1
while IFS='=' read -r NAME COMMAND
do
    echo "$option_number.) $NAME"
    COMMANDS+=("$COMMAND")
    ((option_number+=1))
done < $CHANNEL_LIST_PATH
last_option=$option_number
echo "or..."
echo "$last_option.) Add new channel"
echo -n "Select a channel: "

read USER_INPUT
# echo "You entered: $USER_INPUT which is: ${COMMANDS[$users_selection - 1]}"
if (( USER_INPUT < last_option ))
then
    echo "Opening channel..."
    ${COMMANDS[$USER_INPUT - 1]}
else
    echo "Creating new channel entry..."
    echo -n "Enter an alias for the channel: "
    read user_channel_alias
    echo -n "Enter a channel number: "
    read user_channel_num
    echo "${user_channel_alias}=mpv http://${HDHOMERUN_IP}:5004/auto/v${user_channel_num} -fs --deinterlace">> $CHANNEL_LIST_PATH
fi

