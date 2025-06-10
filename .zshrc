# optional homebrew line: 
export PATH=/opt/homebrew/bin:$PATH
 
if [[ -n $SSH_CONNECTION ]]; then
  PROMPT='%F{red}%n@%m%f %~ %# '  # Show username@hostname in red for SSH sessions
else
  PROMPT='%~ %# '  # Minimal prompt for local sessions
fi

alias ll='ls -al'

alias gs='git status'
alias gc='git commit'
alias gd='git diff'
#alias gch='git checkout'
alias gcp='git cherry-pick'
alias gl='git log --first-parent'
alias ga='git add'
alias gb='git branch'

# script for checking out branches based on parts of the name
gch() {
  if [ -z "$1" ]; then
    echo "Usage: checkout_ticket <TICKET-NUMBER>"
    return 1
  fi

  matches=($(git branch --format="%(refname:short)" --list "*$1*"))

  if [ ${#matches[@]} -eq 0 ]; then
    echo "❌ No local branch found containing '$1'"
    return 1
  elif [ ${#matches[@]} -gt 1 ]; then
    echo "⚠️  Multiple branches found containing '$1':"
    for branch in "${matches[@]}"; do
      echo "  $branch"
    done
    echo "❗ Please specify more characters to narrow it down."
    return 1
  else
    git checkout "${matches[1]}" # 1-indexed since zsh, would need to change to work in bash
  fi
}

# fix so we do 'git push -u' if we are creating the branch, so we automatically track branches
# this is taken from https://stackoverflow.com/a/19021888/249871
alias gpush='[[ -z $(git config "branch.$(git symbolic-ref --short HEAD).merge") ]] && 
           git push -u origin $(git symbolic-ref --short HEAD) || 
           git push'

alias sd='say done'

# fix git autocomplete
autoload -Uz compinit && compinit