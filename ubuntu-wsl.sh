#!/usr/bin/bash
set -euo pipefail
DOTFILE=${HOME}/.config/dotfile
KB_DOTFILE=${HOME}/.config/kb_dotfile


SSHWIN="/mnt/c/Users/jgsqware/Downloads/id_rsa"
SSHKEY="/tmp/id_rsa"
echo "Configure Enpass and put ssh key in ${SSHWIN}"

read -p "Press any key to continue... " -n1 -s

echo ""

mv $SSHWIN $SSHKEY
chmod 600 ${SSHKEY}

if [[ ! -d ${KB_DOTFILE} ]]; then
    ssh-agent bash -c "ssh-add ${SSHKEY}; git clone git@github.com:jgsqware/kb_dotfile.git ${KB_DOTFILE}"  
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
. /home/jgsqware/.nix-profile/etc/profile.d/nix.sh
echo ". /home/jgsqware/.nix-profile/etc/profile.d/nix.sh" > .profile
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-shell '<home-manager>' -A install
ln -fs $HOME/.config/kb_dotfile/nixpkgs/home.nix .config/nixpkgs/home.nix
home-manager switch
