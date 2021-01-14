set fish_greeting

# PATH
set PATH /home/jgsqware/.cargo/bin $PATH

# alias

alias cat=batcat
alias ls='exa -l'
alias ps='procs'
# alias grep='rg'
alias top='btm'
alias cd='z'

# Source
starship init fish | source
zoxide init fish | source
