#!/usr/bin/bash

compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

alias proton="DRI_PRIME=1 STEAM_COMPAT_DATA_PATH=$XDG_DATA_HOME/proton $XDG_DATA_HOME/Steam/steamapps/common/Proton*5.13/proton run"

alias protontricks="WINEPREFIX=$XDG_DATA_HOME/proton/pfx winetricks"
