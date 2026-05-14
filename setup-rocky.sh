#!/bin/bash

# Set up docker
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl --now enable docker
sudo usermod -a -G docker $(whoami)

# Install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
echo 'eval "$(zoxide init --cmd cd bash)"' >> ~/.bashrc

# Install fzf
sudo dnf -y install ripgrep
cat <<EOF >> ~/.bashrc
if type rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
fi
EOF

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Install Vim
git clone https://github.com/vtannguyen/vim-dotfiles.git ~/.vim && cp ~/.vim/.vimrc ~/
cd ~/.vim
./install_formatters.sh
cd ../

# Setup bash aliases
cat <<EOF >> ~/.bashrc
alias ..="cd .."
alias ll="ls -la"
alias va="source .venv/bin/activate"
alias ve="python -m venv .venv"
alias vp="pip install pylint mypy black isort autoflake pip-tools"
# Set vi for bash editing mode
set -o vi
# Set vi as the default editor for all apps that check this
EDITOR=vi
EOF
