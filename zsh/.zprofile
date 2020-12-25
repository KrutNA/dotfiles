# XDG user directories
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share

export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc

# zsh hist file
export HISTFILE="$XDG_DATA_HOME"/zsh/history
# zsh cache?..
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

# Setup directory for user specified binaries
export PATH=$HOME"/.local/bin":$PATH

# Setup XDG for Rustlang
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
# Setup PATH to cargo binaries, installed through `cargo install`
export PATH="$CARGO_HOME"/bin:"$PATH"

# Setup XDG for Julia
export JULIA_DEPOT_PATH="$XDG_CONFIG_HOME"/julia

# Setub XDG for Java and Gradle
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

# fuck nodejs and npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc

# Setup XDG for Golang
# idk, not now, but may be
export GOPATH="$XDG_DATA_HOME"/go

# Setup XDG for Wine
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default
