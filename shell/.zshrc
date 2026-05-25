#!/bin/zsh

#==============================================================================
# ENVIRONMENT VARIABLES
#==============================================================================
# Theme setting for bat command (syntax highlighting)
BAT_THEME="DarkNeon"
# History file configuration
HISTFILE=~/.zsh_history
HISTSIZE=3000
SAVEHIST=$HISTSIZE
HISTDUP=erase
# Directory for storing zsh plugin dependencies
DEPENDENCIES_DIR="$HOME/.config/zsh/dependencies"

#==============================================================================
# HISTORY OPTIONS
#==============================================================================
# Append history entries
setopt appendhistory
# Share history across multiple zsh sessions
setopt sharehistory
# Don't record commands that start with space
setopt hist_ignore_space
# Remove duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_all_dups
# Don't save duplicates
setopt hist_save_no_dups
# Ignore duplicates when searching
setopt hist_ignore_dups
# When searching history don't display duplicates
setopt hist_find_no_dups

#==============================================================================
# COMPLETION SYSTEM CONFIGURATION
#==============================================================================
# Initialize the completion system
autoload -Uz compinit
compinit

# Basic completion configuration
zstyle ':completion:*' menu select
zstyle ':completion:*' auto-list true
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' accept-exact true
# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Key bindings and additional completion settings
bindkey '^I' expand-or-complete
setopt complete_in_word
setopt correct

# Advanced completion settings
zstyle ':completion:*' completer _complete _correct _approximate
setopt menucomplete

# Completion menu styling
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%B%d%b'
zstyle ':completion:*:warnings' format '%B%d%b'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
autoload -U colors && colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

#==============================================================================
# PROMPT CONFIGURATION
#==============================================================================
SPACESHIP_PROMPT_ASYNC=true
eval "$(starship init zsh)"

#==============================================================================
# ALIASES - EDITOR AND NAVIGATION
#==============================================================================
# Quick editor access
alias v="nvim ."
alias c="code . --profile m"
alias z='zellij a'
# Git
alias gb='git switch $(git branch | fzf)'
# Fuzzy find with neovim integration
alias vf='nvim $(fzf --preview "batcat --style=numbers --color=always {}" --preview-window=up:65%)'
alias vwf='nvim $(find "${HOME}/work" -type f | fzf --preview="batcat --style=numbers --color=always {}" --preview-window=up:65%)'
alias vfG='nvim $(find "$HOME" -type f | fzf --preview="batcat --style=numbers --color=always {}" --preview-window=up:65%)'

# Directory navigation with neovim
alias vd='cd $(find . -type d | fzf -e) && nvim .'
alias vwd='cd $(find "$HOME/work" -type d | fzf -e) && nvim .'
alias vdG='cd $(find "$HOME" -type d | fzf -e) && nvim .'

# Quick directory navigation
alias gd='cd $(find . -type d | fzf -e)'
alias gwd='cd $(find "$HOME/work" -type d | fzf -e)'
alias gdG='cd $(find "$HOME" -type d | fzf -e)'

#==============================================================================
# ALIASES - FILE OPERATIONS
#==============================================================================
# Interactive file management
alias rfile='rm -i $(find . -type f | fzf --preview="batcat --style=numbers --color=always {}" --preview-window=up:75%)'
alias fcp='fzf | xargs -I {} echo -n $(realpath {}) | xclip -selection clipboard'

# System operations
alias limpia-cache-en-ram='sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches'

# Enhanced listing commands
alias la='ls -lAhF --color=auto --block-size=K --group-directories-first'
alias al='ls -lhF --color=auto --block-size=K --group-directories-first'
alias L='ls -ChF  --color=auto --block-size=K --group-directories-first'
alias du='du -h --max-depth=1'

#==============================================================================
# FZF (FUZZY FINDER) CONFIGURATION
#==============================================================================
load_fzf() {
    command -v fzf >/dev/null 2>&1 || return 1

    local fzf_completion="/usr/share/fzf/completion.zsh"
    [[ -f "$fzf_completion" ]] && source "$fzf_completion"

    local fzf_keybindings="/usr/share/fzf/key-bindings.zsh"
    [[ -f "$fzf_keybindings" ]] && source "$fzf_keybindings"
}
load_fzf

#==============================================================================
# PLUGINS AND DEPENDENCIES
#==============================================================================
# Auto-install zsh-autosuggestions if not present
if [[ ! -e $DEPENDENCIES_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $DEPENDENCIES_DIR/zsh-autosuggestions
fi
source $DEPENDENCIES_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
# Load fnm

FNM_PATH="~/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
    export PATH="$FNM_PATH:$PATH"
    eval "$(fnm env --use-on-cd --shell zsh)"
    # eval "`fnm env `"
fi
