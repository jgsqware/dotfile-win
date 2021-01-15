  
#!/usr/bin/bash
set -euo pipefail

function xapt() {
    sudo apt install -y -qq "$@"
}

function xcargo() {
    cargo install "$@"
}

function xpip(){
    pip install "$1" --user --upgrade
}

export XDG_CONFIG_HOME="${HOME}/.config"

DOTFILE=${HOME}/.config/dotfile
KB_DOTFILE=${HOME}/.config/kb_dotfile


SSHKEY="/mnt/c/Users/jgsqware/Downloads"
echo "Configure Enpass and put ssh key in ${SSHKEY}"

read -p "Press any key to continue... " -n1 -s

echo ""

chmod 400 ${SSHKEY}/id_rsa
chmod 644 ${SSHKEY}/id_rsa.pub

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

rm -rf ${HOME}/.ssh
ln -fs ${KB_DOTFILE}/ssh/ ${HOME}/.ssh
chmod 400 ${HOME}/.ssh/id_rsa
chmod 644 ${HOME}/.ssh/id_rsa.pub
gpg --import ${KB_DOTFILE}/gpg/gpg-private-keys.asc
gpg --import ${KB_DOTFILE}/gpg/gpg-public-keys.asc
gpg --import-ownertrust ${KB_DOTFILE}/gpg/otrust.txt

ln -sf ${KB_DOTFILE}/.gitconfig ${HOME}/.gitconfig
ln -sf ${KB_DOTFILE}/.gitignore_global ${HOME}/.gitignore_global

# Bash

sudo apt update

xapt \
    fish \
    build-essential \
    libssl-dev \
    fzf \
    ripgrep \
    xclip \
    go \
    python-pip \
    jq

xpip \
    yq

sudo sed -i '/\/usr\/.crates2.json/d' /var/lib/dpkg/info/ripgrep.list
xapt bat
sudo ln -s batcat /usr/bin/bat


# Fish
ln -sf ${DOTFILE}/fish ~/.config/fish
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install jethrokuan/fzf

curl -fsSL https://starship.rs/install.sh | bash
ln -sf ${DOTFILE}/starship.toml ~/.config/starship.toml

sudo chsh -s /usr/bin/fish


# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Cargo

xcargo \
    exa \
    procs \
    zoxide \
    bottom
