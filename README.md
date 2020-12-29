# dotfiles @hugoogb

Screenshots go here

# Table of contents

- [Install & setup](#install--setup)
  - [Dual boot Arch Linux & Windows](#dual-boot-arch-linux--windows)
    - [Keyboard layout](#keyboard-layout)
    - [Verify connection](#verify-connection)
    - [Update the system clock](#update-the-system-clock)
    - [Disk partition](#important-disk-partition-dual-boot-windows-10)
    - [Format the partitions](#format-the-partitions)
    - [Mount the partitions](#mount-the-partitions)
    - [Install essential packages](#install-essential-packages)
    - [Generate fstab](#generate-fstab)
    - [Chroot](#chroot)
    - [Time zone](#time-zone)
    - [Localization](#localization)
    - [Network connection](#network-connection)
    - [Add root password](#add-root-password)
    - [Add new user](#add-new-user)
    - [GRUB install](#grub-install)
    - [Network manager](#network-manager)
    - [Sudo](#sudo)
    - [Exit, unmount and reboot](#exit-unmount-and-reboot)
    - [Connect to your network](#connect-to-your-network)
  - [Arch linux setup](#arch-linux-setup)
    - [Install git](#install-git)
    - [Clone repo](#clone-repo)
    - [Bootstrap](#bootstrap)
- [Keybindings](#keybindings)
  - [Windows](#windows)
  - [Apps](#apps)

# Install & setup

[Official arch install guide](https://wiki.archlinux.org/index.php/installation_guide)

## Dual boot Arch Linux & Windows

### Keyboard layout

```sh
# Avaliable layouts: ls /usr/share/kbd/keymaps/**/*.map.gz
loadkeys es # Spanish for example
```

### Verify connection

```sh
ping google.com
```

### Update the system clock

```sh
timedatectl set-ntp true
```

### **IMPORTANT** Disk partition (dual boot Windows 10)

```sh
# Find out the name of your drive (sometimes /dev/sda - I'll be using /dev/nvme0n1)
fdisk -l

# You should see something like that
Device                   Start           End     Sectors     Size    Type
/dev/nvme0n1p1            2048        206847      204800     100M    EFI System
/dev/nvme0n1p2          206848        239615       32768      16M    Microsoft reserved
/dev/nvme0n1p3          239616     579717593   579477978   276.3G    Microsoft basic data
/dev/nvme0n1p4       999151616    1000212479     1060864     518M    Windows Recovery environment

fdisk /dev/nvme0n1

# Boot partition
n                    # New partition
<Enter>              # Default partition number
<Enter>              # Default starting sector
+512MB               # Enter the size you want your boot sector to be
t                    # Change the partition type
<Enter>              # Use default partition
1                    # Change partition type to EFI System

# Swap partition
n                    # New partition
<Enter>              # Default partition number
<Enter>              # Default starting sector
+1.5G                # Enter the size you want your swap to be
t                    # Change the partition type
<Enter>              # Use default partition
19                   # Change partition type to Linux swap

# Root partition
n                    # New partition
<Enter>              # Default partition number
<Enter>              # Default starting sector
<Enter>              # Fill the rest of the disk

# Write partitions
w                    # Write the changes to disk & exit

# Look at the partitions
fdisk -l

# Now you should have something like that
Device                   Start           End     Sectors     Size    Type
/dev/nvme0n1p1            2048        206847      204800     100M    EFI System
/dev/nvme0n1p2          206848        239615       32768      16M    Microsoft reserved
/dev/nvme0n1p3          239616     579717593   579477978   276.3G    Microsoft basic data
/dev/nvme0n1p4       999151616    1000212479     1060864     518M    Windows Recovery environment
/dev/nvme0n1p5       579719168     580767743     1048576     512M    EFI System
/dev/nvme0n1p6       580767744     583913471     3145728     1.5G    Linux swap
/dev/nvme0n1p7       583913472     999151615   415238144     198G    Linux filesystem
```

### Format the partitions

```sh
# Boot partition
mkfs.fat -F32 /dev/nvme0n1p5 # Your boot partition

# Swap partition
mkswap /dev/nvme0n1p6 # Your swap partition

# Root partition
mkfs.ext4 /dev/nvme0n1p7 # Your root partition
```

### Mount the partitions

```sh
# Swap partition
swapon /dev/nvme0n1p6 # Your swap partition

# Root partition
mount /dev/nvme0n1p7 /mnt # Your root partition

# Boot partition
mkdir /mnt/boot
mount /dev/nvme0n1p5 /mnt/boot # Your boot partition
```

Look at mounted devices: `df`

### Install essential packages

```sh
pacstrap /mnt base linux linux-firmware nano
```

### Generate fstab

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

Check the resulting file, edit in case of errors

```sh
cat /mnt/etc/fstab
```

### Chroot

```sh
arch-chroot /mnt
```

### Time zone

```sh
# ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime # Spain for example
hwclock --systohc
```

### Localization

Edit **/etc/locale.gen** and uncomment needed locales such as `en_US.UTF-8 UTF-8`.
Generate the locales:

```sh
locale-gen
```

Set the LANG variable

```sh
echo "LANG=en_US.UTF-8" > /etc/locale.conf # English for example
```

Set the keyboard layout

```sh
echo "KEYMAP=es" > /etc/vconsole.conf # Spanish for example
```

### Network connection

Set your hostname

```sh
echo "asus-laptop" > /etc/hostname # Example
```

Edit **/etc/hosts** and add matching entries

```sh
nano /etc/hosts

# Add this
127.0.0.1    localhost
::1          localhost
127.0.1.1    myhostname.localdomain	myhostname # myhostname is your hostname in /etc/hostname
```

### Add root password

```sh
passwd
```

### Add new user

```sh
useradd -m username # Username for the new user
passwd username # Password for the user created
usermod -aG power,wheel,video,audio,storage username # Give the user permissions
```

Edit **/etc/sudoers** and uncomment this line:

```sh
## Uncomment to allow members of group wheel to execute any command
# %wheel ALL=(ALL) ALL --> %wheel ALL=(ALL) ALL
```

### GRUB install

```sh
# Install needed packages
pacman -S grub efibootmgr os-prober

# Grub install
os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub

# Mount Windows EFI System
fdisk -l # Look at the partitions
mkdir /mnt2
mount /dev/nvme0n1p1 /mnt2 # Mount your Windows EFI System partition

# Grub setup
grub-mkconfig -o /boot/grub/grub.cfg
```

The command output should be something like:

```sh
Found linux image: ...
Found initrd image: ...
Found fallback initrd image(s) ...
Found Windows Boot Manager on ...
```

### Network manager

```sh
pacman -S networkmanager
systemctl enable NetworkManager
```

### Sudo

```sh
pacman -S sudo
```

### Exit, unmount and reboot

```sh
exit
umount -R /mnt
reboot
```

### Connect to your network

```sh
# List all available networks
nmcli device wifi list
# Connect to your network
nmcli device wifi connect YOUR_SSID password YOUR_PASSWORD
```

## Arch linux setup

### Install git

```sh
sudo pacman -S git
```

### Clone repo

```sh
git clone https://github.com/hugoogb/dotfiles.git ~/dotfiles
```

### Bootstrap

```sh
. ~/dotfiles/bootstrap.sh
```

# Keybindings

## Windows

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
