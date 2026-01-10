# pro tip:
# just reference this file in your .zshrc like this:
# source ~/my-repos/linuxconfig/.zshrc 

export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY


if [[ -n $SSH_CONNECTION ]]; then
  PROMPT='%F{red}%n@%m%f %~ %# '  # Show username@hostname in red for SSH sessions
else
  PROMPT='%~ %# '  # Minimal prompt for local sessions
fi

alias ll='ls -al'

alias gs='git status'
alias gc='git commit'
alias gd='git diff'
alias gch='git checkout'
alias gcp='git cherry-pick'
alias gl='git log --first-parent'
alias ga='git add'
alias gb='git branch'
alias gr='git restore'

# script for switching to branches based on parts of the name 
gsw() {
  if [ -z "$1" ]; then
    echo "Usage: gsw <PART-OF-BRANCH-NAME>"
    return 1
  fi

  local -a locals remotes
  local b

  # Check local branches first
  locals=($(git branch --format="%(refname:short)" --list "*$1*"))

  if [ ${#locals[@]} -eq 1 ]; then
    git switch -- "${locals[1]}"   # 1-indexed since zsh, would need to change to work in bash
    return
  elif [ ${#locals[@]} -gt 1 ]; then
    echo "⚠️  Multiple *local* branches found containing '$1':"
    printf '  %s\n' "${locals[@]}"
    echo "❗ Please specify more characters to narrow it down."
    return 1
  fi

  # Check remote branches
  # the grep is necessary to skip `HEAD` in the unlikely scenario that `HEAD` matches the argument
  remotes=($(git branch -r --format="%(refname:short)" --list "*$1*" | grep -v '/HEAD$'))

  if [ ${#remotes[@]} -eq 0 ]; then
    echo "❌ No branch (local or remote) found containing '$1'"
    return 1
  elif [ ${#remotes[@]} -gt 1 ]; then
    echo "⚠️  Multiple *remote* branches found containing '$1':"
    printf '  %s\n' "${remotes[@]}"
    echo "❗ Please specify more characters to narrow it down."
    return 1
  else
    b="${remotes[1]}"  # 1-indexed since zsh, would need to change to work in bash
    git switch --track -- "$b"
  fi
}

# fix git autocomplete
autoload -Uz compinit && compinit