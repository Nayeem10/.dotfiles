# run fastfetch upon opening a terminal
# Check if this is the only kitty instance running
# if [ $(pgrep -c kitty) -eq 1 ]; then
#     fastfetch
# fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# --- Environment variables ---
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# define EDITOR variable to work with yazi
export EDITOR=nvim



# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias insomnia="gnome-session-inhibit --inhibit idle sleep infinity"
alias start-oracle="rlwrap sqlplus system/nayeem#2110@//localhost:1521/XE"
alias tt="taskwarrior-tui"
#alias start-oracle="sudo docker start oracle-xe && sudo docker exec -it oracle-xe sqlplus sys/nayeem#2110 as sysdba"
#alias stop-oracle="sudo docker stop oracle-xe"



# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

autoload -Uz compinit
compinit

# zsh-autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# My configs

# Auto-start tmux if not already inside one
#if command -v tmux &> /dev/null; then
#  [ -z "$TMUX" ] && exec tmux
#fi

# Run neofetch only inside tmux
#if [ -n "$TMUX" ]; then
#  neofetch
#fi

# mpv configs
# mpv config to play youtube video. Currently this is also configured in mpv config
ytmusic() {
    mpv --no-video \
        --really-quiet \
        --msg-level=all=status,cplayer=no,ffmpeg=no,ao=no,demuxer=no \
        --term-playing-msg="----------------------------------------\nNOW PLAYING: \${media-title}\n----------------------------------------" \
        --term-status-msg="[\${playback-time/full} / \${duration/full}] \${percent-pos}%" \
        --ytdl-raw-options="cookies-from-browser=brave" \
        "$@"
}

# yazi configs
# use y instead of yazi to start, and press q to quit, you'll see the CWD changed. Sometimes, you don't want to change, press Q to quit.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Detect if we are running inside Neovim's terminal emulator
if [ -n "$NVIM" ]; then
  # 1. Strip down the prompt elements for the ACTIVE line
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=() # Completely empty the right side

  # 2. Convert from 2-line "Lean" or "Classic" to a simple 1-line prompt
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{cyan}❯%f "

  # 3. Strip block backgrounds and frame details (Force a clean, flat style)
  typeset -g POWERLEVEL9K_DIR_FOREGROUND='cyan'
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='cyan'
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='cyan'
  
  # Remove the connection lines/brackets entirely
  typeset -g POWERLEVEL9K_LEFT_SUBSHORTCUT_DELIMITER=
  typeset -g POWERLEVEL9K_RIGHT_SUBSHORTCUT_DELIMITER=
  
  # 4. Fallback default prompt symbol just in case
  PROMPT="%F{cyan}❯%f "
fi

# omnetpp config
# set environment variables and run omnetpp 
# [ -f "$HOME/APPS/omnetpp-6.4.0/setenv" ] && source "$HOME/APPS/omnetpp-6.4.0/setenv"
