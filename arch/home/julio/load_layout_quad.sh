#!/bin/sh

i3-msg "gaps inner current set 0"
i3-msg "gaps outer current set 0"
i3-msg "gaps horizontal current set 500"

i3-msg "append_layout ~/.config/i3/workspace_quad.json"

#i3-msg "exec alacritty --class Alacritty-TopLeft"
#i3-msg "exec alacritty --class Alacritty-TopRight"
#i3-msg "exec alacritty --class Alacritty-BottomLeft"
#i3-msg "exec alacritty --class Alacritty-BottomRight"

