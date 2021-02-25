# dotfiles @hugoogb

## Gallery

![alacritty terminal](/img/terminal.png)

![qtile](/img/qtile.png)

# Table of contents

- [Arch linux setup](#arch-linux-setup)
  - [Install git](#install-git)
  - [Clone and execute script](#clone-and-execute-script)
  - [Curl command](#curl-command)
- [Keybindings](#keybindings)
  - [Windows](#windows)
  - [Apps](#apps)

# Arch linux setup

## Install git

```sh
sudo pacman -S git
```

## Clone and execute script

You can clone and execute the bootstrap script or just use the curl command below

### Clone repo

```sh
git clone https://github.com/hugoogb/dotfiles.git ~/dotfiles
```

### Bootstrap script

```sh
. ~/dotfiles/bootstrap.sh
```

## Curl command

```sh
curl -s https://raw.githubusercontent.com/hugoogb/dotfiles/master/bootstrap.sh | bash
```

# Keybindings

## Window manager

| Key                     | Action                           |
| ----------------------- | -------------------------------- |
| **mod + j**             | Next window (down)               |
| **mod + k**             | Next window (up)                 |
| **mod + shift + h**     | Decrease master                  |
| **mod + shift + l**     | Increase master                  |
| **mod + shift + j**     | Move window down                 |
| **mod + shift + k**     | Move window up                   |
| **mod + shift + f**     | Toggle floating                  |
| **mod + tab**           | Change layout                    |
| **mod + [1-9]**         | Switch to workspace N (1-9)      |
| **mod + shift + [1-9]** | Send Window to workspace N (1-9) |
| **mod + period**        | Focus next monitor               |
| **mod + comma**         | Focus previous monitor           |
| **mod + w**             | Kill window                      |
| **mod + ctrl + r**      | Restart wm                       |
| **mod + ctrl + q**      | Quit                             |

## Apps

| Key                 | Action                        |
| ------------------- | ----------------------------- |
| **mod + m**         | Launch rofi                   |
| **mod + shift + m** | Window nav (rofi)             |
| **mod + b**         | Launch browser (firefox)      |
| **mod + e**         | Launch file explorer (thunar) |
| **mod + return**    | Launch terminal (alacritty)   |
| **mod + s**         | Screenshot (scrot)            |
