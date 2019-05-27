#!/bin/bash
i3-msg "mode default"
sleep 0.1
xdotool type "`xsel -op`"
sleep 0.1
i3-msg "mode COPY"
