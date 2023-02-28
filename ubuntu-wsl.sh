#!/usr/bin/bash
# set -euo pipefail
# set BRANCH to first arg if defined or default to simple
BRANCH=${1:-simple}
DOTFILE=${HOME}/.config/dotfile-win
KB_DOTFILE=${HOME}/.config/kb_dotfile
SSHKEY=~/.ssh/id_rsa

if [[ ! -f $SSHKEY ]]; then
    
    SSHWIN="/mnt/c/Users/jgsqware/Downloads/id_rsa"
    SSHKEY="/tmp/id_rsa"
    echo "Configure Enpass and put ssh key in ${SSHWIN}"

    read -p "Press any key to continue... " -n1 -secho ""
    mv $SSHWIN $SSHKEY
    chmod 600 ${SSHKEY}
fi

if [[ ! -d ${KB_DOTFILE} ]]; then
    ssh-agent bash -c "ssh-add ${SSHKEY}; git clone git@github.com:jgsqware/kb_dotfile.git ${KB_DOTFILE}"
    (cd ${KB_DOTFILE}; git checkout ${BRANCH}) 
else
    (
        cd ${KB_DOTFILE}
        ssh-agent bash -c "ssh-add ${SSHKEY}; git stash"          
        ssh-agent bash -c "ssh-add ${SSHKEY}; git pull -r"  
        ssh-agent bash -c "ssh-add ${SSHKEY}; git stash pop" || echo   

    )
fi

if [[ ! -d ${DOTFILE} ]]; then
    ssh-agent bash -c "ssh-add ${SSHKEY}; git clone git@github.com:jgsqware/dotfile-win.git ${DOTFILE}"  
else
    (
        cd "${DOTFILE}"
        ssh-agent bash -c "ssh-add ${SSHKEY}; git stash"          
        ssh-agent bash -c "ssh-add ${SSHKEY}; git pull -r"  
        ssh-agent bash -c "ssh-add ${SSHKEY}; git stash pop" || echo
    )
fi

cd $HOME
curl -L https://nixos.org/nix/install | sh -s
. /home/$(whoami)/.nix-profile/etc/profile.d/nix.sh
echo ". /home/$(whoami)/.nix-profile/etc/profile.d/nix.sh" > .profile
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
mkdir -m 0755 -p /nix/var/nix/{profiles,gcroots}/per-user/$USER
nix-shell '<home-manager>' -A install
ln -fs $HOME/.config/kb_dotfile/nixpkgs/home.nix .config/nixpkgs/home.nix
home-manager switch
echo "/home/$(whoami)/.nix-profile/bin/zsh" | sudo tee -a /etc/shells
chsh -s /home/$(whoami)/.nix-profile/bin/zsh
