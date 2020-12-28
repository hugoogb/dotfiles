# (DEPRECATED README) dotfiles @hugoogb

## Screenshots

## Welcome to my dotfiles !

First of all, I'm using `WSL2 Ubuntu` in Windows 10

Right now the terminal that I'm using is [alacritty] with the `gruvbox-dark` theme

- See alacritty config [here]

I'm starting in the world of dotfiles so don't be mad at me 😅

I've trying to customize and configure `.vimrc` & `.zshrc` mostly and I think they are pretty good right now, at least they work 😂

### Features

- My dotfiles include the installation of: `htop neofetch neovim curl git zsh oh-my-zsh fzf nodejs npm yarn tree tmux`

- **zsh** theme `starship` you can see it in their website: [starship]

- **zsh** plugins `(git jump colored-man-pages safe-paste zsh-interactive-cd zsh-syntax-highlighting k)` | jump plugin config: [documentation]

- some **zsh** aliases: see them on `.zshrc`

- **nvim** theme `gruvbox-dark`

- **nvim** plugins `(indentLine nerdtree nerdtree-syntax-highlight nerdtree-git-plugin vim-devicons fzf vim-tmux-navigator coc vim-airline vim-wakatime undotree vimspector)`

- **tmux** theme `gruvbox-dark`

- **tmux** setup `.tmux.conf` with vim keybindings and Tmux Plugin Manager ([tpm])

## Install & setup

Official install guide: https://wiki.archlinux.org/index.php/installation_guide

### Dual boot Arch Linux & Windows: 
https://www.youtube.com/watch?v=C3D_qzw94v8
https://gist.github.com/ppartarr/175aa0c3416daf3baacde17f442f80e1

```sh
pacman -S networkmanager
systemctl enable NetworkManager
```

```sh
pacman -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/boot
os-prober
grub-mkconfig -o /boot/grub/grub.cfg
```

```sh
useradd -m username
passwd username
usermod -aG wheel,video,audio,storage username
```

```sh
pacman -S sudo
```

```sh
## Uncomment to allow members of group wheel to execute any command
# %wheel ALL=(ALL) ALL
```

```sh
# Exit out of ISO image, unmount it and remove it
exit
umount -R /mnt
reboot
```

```sh
# List all available networks
nmcli device wifi list
# Connect to your network
nmcli device wifi connect YOUR_SSID password YOUR_PASSWORD
```

**- 1.** Install `git` and Clone the repository

```sh
sudo apt install git
```

```sh
git clone https://github.com/hugoogb/dotfiles.git
```

**- 2.** Execute `bootstrap.sh`

```sh
sh ~/dotfiles/bootstrap.sh
```

**- 3.** Follow the installation and setup scripts

Pick the options that you want and thats all, everythings is properly explained with terminal messages

### You are all done ✅

Everything installs and configs automatically (i hope so) thanks to the scripts

[alacritty]: https://github.com/alacritty/alacritty
[here]: https://github.com/hugoogb/alacritty
[documentation]: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/jump
[starship]: https://starship.rs/
[tpm]: https://github.com/tmux-plugins/tpm
