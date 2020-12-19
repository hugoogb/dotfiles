# (DEPRECATED README) dotfiles @hugoogb

## Screenshots

### zsh | tmux

![zsh tmux](images/zsh-tmux.png)

### vim

![vim](images/vim.png)

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
