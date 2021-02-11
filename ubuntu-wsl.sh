  
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

sudo apt upgrade

xapt \
    fish \
    build-essential \
    libssl-dev \
    fzf \
    ripgrep \
    xclip \
    golang \
    python3-pip \
    jq \
    npm

xpip \
    yq

sudo sed -i '/\/usr\/.crates2.json/d' /var/lib/dpkg/info/ripgrep.list
xapt bat
sudo ln -s batcat /usr/bin/bat
curl -fsSL https://starship.rs/install.sh | bash

# Kubernetes
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Cargo

xcargo \
    exa \
    procs \
    zoxide \
    bottom

sudo groupadd docker
sudo usermod -aG docker $USER


bash -c "fish ${DOTFILE}/install.fish"

sudo chsh -s /usr/bin/fish $(whoami)