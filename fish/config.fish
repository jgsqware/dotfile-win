set fish_greeting

if status is-interactive
    cd /home/jgsqware/go/src/github.com
end

# PATH
set GOPATH $HOME/go
set XDG_CONFIG_HOME $HOME/.config
set DOTFILE $HOME/.config/dotfile
set KB_DOTFILE $HOME/.config/kb_dotfile

set PATH $HOME/.local/bin $HOME/.cargo/bin $DOTFILE/bin $KB_DOTFILE/bin $GOPATH/bin /usr/local/go/bin $PATH

set FZF_COMPLETE 2

# less syntax highlighting + source-highlight installation
set LESSOPEN "| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"

# alias

alias cat=batcat
alias ls='exa -l'
alias ps='procs'
# alias grep='rg'
alias top='btm'
# alias cd='z'
alias h="history"
alias less='less -R'

alias config="code $DOTFILE"
alias credentials="nvim $HOME/.aws/credentials"

## Kubernetes

alias k='kubectl'

# Source
starship init fish | source
zoxide init fish | source
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
