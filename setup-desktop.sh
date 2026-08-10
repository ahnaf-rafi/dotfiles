#!/usr/bin/env bash

sudo dnf5 install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


sudo dnf5 install -y \
     dnf5-plugins coreutils stow which git git-delta wget curl \
     zip unzip tar tree gcc make cmake autoconf automake fzf ripgrep fd-find \
     bat fastfetch neovim python3-neovim tmux \
     @hardware-support pciutils usbutils smartmontools \
     NetworkManager-wifi wpa_supplicant \
     NetworkManager-bluetooth bluez \
     pipewire wireplumber pipewire-alsa pipewire-pulseaudio \
     alsa-utils texlive-scheme-full \
     adwaita-icon-theme adwaita-fonts-all liberation-fonts \
     google-noto-sans-fonts google-noto-color-emoji-fonts

sudo dnf5 install -y fastfetch tmux
sudo dnf5 upgrade --refresh
sudo dnf5 install -y akmod-nvidia xorg-x11-drv-nvidia-cuda libva-nvidia-driver

# TODO: TEMP REMOVE PLEASE

sudo systemctl --user enable --now pipewire
sudo systemctl --user enable --now pipewire-pulse
sudo systemctl --user enable --now wireplumber

mkdir -p ~/.local/share/fonts

wget https://github.com/cormullion/juliamono/releases/latest/download/JuliaMono.zip
unzip JuliaMono.zip -d ~/.local/share/fonts/JuliaMono
rm JuliaMono.zip

wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
rm JetBrainsMono.zip

wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip
unzip NerdFontsSymbolsOnly.zip -d ~/.local/share/fonts/SymbolsOnlyNerdFont
rm NerdFontsSymbolsOnly.zip

fc-cache -fv

git clone git@github.com:ahnaf-rafi/dotfiles.git $HOME/dotfiles

rm ~/{.bash_profile,.bashrc,.bash_logout,.vim}

cd $HOME/dotfiles/
stow .

sudo dnf5 config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo dnf5 install -y brave-browser

sudo dnf copr enable lionheartp/Hyprland

sudo dnf5 install -y \
     hyprland hyprland-guiutils hyprshutdown hyprpaper hyprpolkitagent rofi \
     xdg-desktop-portal-hyprland xdg-desktop-portal \
     kitty foot waybar mako kanshi nautilus fontawesome-fonts-all \
     pavucontrol network-manager-applet blueman \
     vim-X11 zathura zathura-pdf-mupdf zathura-djvu zathura-ps

systemctl --user enable kanshi.service

sudo dnf copr enable alternateved/bleeding-emacs
# By default, the above copr repo installs emacs with PGTK support.
# libtool and libvterm are dependencies for emacs-libvterm.
# tree-sitter-cli is required to deal with tree-sitter-latex.
# The remaining extras are dependencies for the pdf-tools emacs package.
sudo dnf install emacs libtool libvterm tree-sitter-cli autoconf automake gcc \
     libpng-devel make poppler-devel poppler-glib-devel zlib-devel pkgconf

emacs -nw

systemctl --user enable --now emacs
