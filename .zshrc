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
    git switch "${matches[1]}" # 1-indexed since zsh, would need to change to work in bash 
  fi 
} 

# fix git autocomplete
autoload -Uz compinit && compinit