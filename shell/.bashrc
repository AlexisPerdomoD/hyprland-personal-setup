#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORM=wayland
export EDITOR=nvim

#==============================================================================
# ENVIRONMENT VARIABLES
#==============================================================================
export BAT_THEME="DarkNeon"
export HISTFILE="$HOME/.bash_history"
export HISTSIZE=3000
export HISTCONTROL=ignoredups:erasedups:ignorespace
DEPENDENCIES_DIR="$HOME/.config/bash/dependencies"

#==============================================================================
# HISTORY OPTIONS
#==============================================================================
shopt -s histappend # Append en vez de overwrite
shopt -s cmdhist    # Guardar multilínea como una sola
shopt -s lithist    # Mantener formato literal
# (no existe sharehistory en bash, cada shell maneja su propio hist)

#==============================================================================
# COMPLETION SYSTEM CONFIGURATION
#==============================================================================
# Bash usa bash-completion (instálalo si no lo tienes)
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# Case-insensitive completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "TAB:menu-complete"

#==============================================================================
# PROMPT CONFIGURATION
#==============================================================================
# Starship con bash
eval "$(starship init bash)"

#==============================================================================
# ALIASES
#==============================================================================
alias v="nvim ."
alias c="code . --profile m"
alias z="zellij a"
alias gb='git switch $(git branch | fzf)'
alias vf='nvim $(fzf --preview "batcat --style=numbers --color=always {}" --preview-window=up:65%)'
alias vwf='nvim $(find "$HOME/work" -type f | fzf --preview="batcat --style=numbers --color=always {}" --preview-window=up:65%)'
alias vfG='nvim $(find "$HOME" -type f | fzf --preview="batcat --style=numbers --color=always {}" --preview-window=up:65%)'

alias vd='cd "$(find . -type d | fzf -e)" && nvim .'
alias vwd='cd "$(find "$HOME/work" -type d | fzf -e)" && nvim .'
alias vdG='cd "$(find "$HOME" -type d | fzf -e)" && nvim .'

alias gd='cd "$(find . -type d | fzf -e)"'
alias gwd='cd "$(find "$HOME/work" -type d | fzf -e)"'
alias gdG='cd "$(find "$HOME" -type d | fzf -e)"'

alias rfile='rm -i "$(find . -type f | fzf --preview="batcat --style=numbers --color=always {}" --preview-window=up:75%)"'
alias fcp='fzf | xargs -I {} realpath {} | xclip -selection clipboard'

alias limpia-cache-en-ram='sudo sync; echo 3 | sudo tee /proc/sys/vm/drop_caches'

alias ls='ls --color=auto --block-size=K --group-directories-first'
alias grep='grep --color=auto'
alias la='ls -lAhF --color=auto --block-size=K --group-directories-first'
alias al='ls -lhF --color=auto --block-size=K --group-directories-first'
alias L='ls -ChF  --color=auto --block-size=K --group-directories-first'
alias du='du -h --max-depth=1'

#==============================================================================
# FZF CONFIGURATION
#==============================================================================
load_fzf() {
    command -v fzf >/dev/null 2>&1 || return 1

    local fzf_completion="/usr/share/fzf/completion.bash"
    [[ -f "$fzf_completion" ]] && source "$fzf_completion"

    local fzf_keybindings="/usr/share/fzf/key-bindings.bash"
    [[ -f "$fzf_keybindings" ]] && source "$fzf_keybindings"
}
load_fzf

#==============================================================================
# PLUGINS AND DEPENDENCIES
#==============================================================================
# (no existe autosuggestions nativo en bash; se puede emular con bash-preexec o scripts externos)
# Reemplazo simple: Ctrl+r para búsqueda incremental en historial

# FNM
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
    export PATH="$FNM_PATH:$PATH"
    eval "$(fnm env --use-on-cd --shell bash)"
fi

#==============================================================================
# STARTUP
#==============================================================================
export ZELLIJ_AUTO_ATTACH=true
echo "USR: $USER"
