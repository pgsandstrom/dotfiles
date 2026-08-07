# -----------------------------------------
# HISTORY
# -----------------------------------------

export HISTSIZE=10000000
export HISTFILESIZE=$HISTSIZE
export HISTTIMEFORMAT="%F %T "

export HOMEBREW_NO_UPDATE_REPORT_NEW=1

# -----------------------------------------
# PROMPT
# -----------------------------------------

if [[ -n "$SSH_CONNECTION" ]]; then
  # Red username@host + path + prompt char
  PS1='\[\e[31m\]\u@\h\[\e[0m\] \w \$ '
else
  # Minimal prompt for local sessions
  PS1='\w \$ '
fi

# -----------------------------------------
# ALIASES
# -----------------------------------------

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

# -----------------------------------------
# gsw — switch to branch by substring
# -----------------------------------------

gsw() {
  if [[ -z "$1" ]]; then
    echo "Usage: gsw <PART-OF-BRANCH-NAME>"
    return 1
  fi

  local query="$1"
  local locals remotes b

  # Read local branches into bash array
  mapfile -t locals < <(git branch --format="%(refname:short)" --list "*$query*")

  # Prefer an exact local match (e.g. "main" over "maintenance")
  for b in "${locals[@]}"; do
    if [[ "$b" == "$query" ]]; then
      git switch -- "$b"
      return
    fi
  done

  if (( ${#locals[@]} == 1 )); then
    git switch -- "${locals[0]}"
    return
  elif (( ${#locals[@]} > 1 )); then
    echo "⚠️  Multiple *local* branches found containing '$query':"
    printf '  %s\n' "${locals[@]}"
    echo "❗ Please specify more characters to narrow it down."
    return 1
  fi

  # Remote branches (skip HEAD)
  mapfile -t remotes < <(git branch -r --format="%(refname:short)" --list "*$query*" | grep -v '/HEAD$')

  # Prefer an exact remote match (compares against the branch name without the remote prefix)
  for b in "${remotes[@]}"; do
    if [[ "${b#*/}" == "$query" ]]; then
      git switch --track -- "$b"
      return
    fi
  done

  if (( ${#remotes[@]} == 0 )); then
    echo "❌ No branch (local or remote) found containing '$query'"
    return 1
  elif (( ${#remotes[@]} > 1 )); then
    echo "⚠️  Multiple *remote* branches found containing '$query':"
    printf '  %s\n' "${remotes[@]}"
    echo "❗ Please specify more characters to narrow it down."
    return 1
  else
    b="${remotes[0]}"
    git switch --track -- "$b"
  fi
}

# -----------------------------------------
# Git autocompletion (bash)
# -----------------------------------------

# Git for Windows (Git Bash)
if [ -f /mingw64/share/git/completion/git-completion.bash ]; then
  source /mingw64/share/git/completion/git-completion.bash
# Linux
elif [ -f /usr/share/git/completion/git-completion.bash ]; then
  source /usr/share/git/completion/git-completion.bash
# macOS with Homebrew
elif [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
  source /usr/local/etc/bash_completion.d/git-completion.bash
elif [ -f /opt/homebrew/etc/bash_completion.d/git-completion.bash ]; then
  source /opt/homebrew/etc/bash_completion.d/git-completion.bash
fi

# Wire up git completions for aliases
if type __git_complete &>/dev/null; then
  __git_complete gs _git_status
  __git_complete gc _git_commit
  __git_complete gd _git_diff
  __git_complete gch _git_checkout
  __git_complete gcp _git_cherry_pick
  __git_complete gl _git_log
  __git_complete ga _git_add
  __git_complete gb _git_branch
  __git_complete gr _git_restore
fi
