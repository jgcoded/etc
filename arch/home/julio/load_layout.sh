#!/bin/sh

i3-msg workspace "1:www"; append_layout ~/.config/i3/workspace_1.json

(alacritty &)
(firefox &)
(obsidian &)

