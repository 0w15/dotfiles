# --------------------
# ENVIRONMENT
# --------------------
export EDITOR=nano
export PAGER=less
export BAT_THEME="OneHalfDark"

# Use `fd` for file listing in fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Set bat as the previewer
export FZF_PREVIEW_COMMAND='bat --style=numbers --color=always --line-range=:500 {}'
export FZF_CTRL_T_OPTS="--preview '$FZF_PREVIEW_COMMAND'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# PATH

export PATH=$PATH:~/.local/bin

# -------------------
# Bindkeys
# -------------------
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

# --------------------
# ALIASES
# --------------------
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias cat='bat'
alias y='yazi'

# --------------------
# YAZI INTEGRATION
# --------------------

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# --------------------
# STARSHIP PROMPT
# --------------------
eval "$(starship init zsh)"

# --------------------
# ZSH HISTORY CONFIG
# --------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt append_history           # Don't overwrite history file
setopt hist_ignore_dups         # Skip duplicates when adding to history
setopt hist_ignore_all_dups     # Remove older duplicates
setopt hist_find_no_dups        # Avoid duplicate matches when searching
setopt hist_reduce_blanks       # Strip superfluous whitespace
setopt share_history            # Share between terminals
setopt inc_append_history       # Write immediately to file
setopt extended_history         # Save timestamps

# --------------------
# FZF CTRL+R HISTORY SEARCH
# --------------------
__fzf_history_widget() {
  local selected
  selected=$(fc -l 1 | awk '{$1=""; print substr($0,2)}' | tac | fzf --height 40% --layout=reverse --border --ansi \
    --preview 'echo {} | bat --style=plain --color=always --language=bash' \
    --prompt=' History > ')
  if [[ -n "$selected" ]]; then
    BUFFER="$selected"
    CURSOR=${#BUFFER}
    zle redisplay
  fi
}
zle -N __fzf_history_widget
bindkey '^R' __fzf_history_widget

# --------------------
# ZSH OPTIONS
# --------------------
setopt autocd                 # Type dir name to cd
setopt correct                # Autocorrect minor typos
setopt extended_glob          # Extended globbing

# --------------------
# COMPLETION SYSTEM
# --------------------
autoload -Uz compinit && compinit
autoload -Uz colors && colors

# --------------------
# Plugins
# --------------------
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh