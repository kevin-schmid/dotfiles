sudo apt install git
mkdir -p $HOME/.config/dotfiles
mkdir media
mkdir downloads
git init --initial-branch=main --separate-git-dir=$HOME/.config/dotfiles/ $HOME
mv $HOME/.profile $HOME/.profile_bak
mv $HOME/.bashrc $HOME/.bashrc_bak
git --git-dir=$HOME/.config/dotfiles pull https://github.com/kevin-schmid/dotfiles.git main
source .profile
source .bashrc
sudo apt install -y curl gcc fzf sway i3blocks swaybg foot xdg-desktop-portal-wlr xwayland alsa-utils grimshot mako-notifier mesa-vulkan-drivers vulkan-tools network-manager pavucontrol pipewire-audio flatpak gammastep
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
rm .bash_logout
rm .lesshst
rm .*_bak
rm .git
