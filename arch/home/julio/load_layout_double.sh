#!/bin/sh

i3-msg "gaps inner current set 0"
i3-msg "gaps outer current set 0"
i3-msg "gaps horizontal current set 500"

i3-msg "append_layout ~/.config/i3/workspace_double.json"

#i3-msg "exec alacritty --class Alacritty-ColumnLeft"
#i3-msg "exec alacritty --class Alacritty-ColumnRight"

#i3-msg "[class=\"^Alacritty-ColumnLeft$\"] focus"
