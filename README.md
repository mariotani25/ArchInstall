# ArchLinux Installer Script

<!-- <img src="https://i.imgur.com/YiNMnan.png" /> -->

This README contains the steps I do to install and configure a fully-functional Arch Linux installation containing a desktop environment, all the support packages (network, bluetooth, audio, printers, etc.), along with all my preferred applications and utilities. The shell scripts in this repo allow the entire process to be automated.)

---
## Create Arch ISO or Use Image

Download ArchISO from <https://archlinux.org/download/> and put on a USB drive with [Etcher](https://www.balena.io/etcher/), [Ventoy](https://www.ventoy.net/en/index.html), or [Rufus](https://rufus.ie/en/)

<!-- If you don't want to build using this script I did create an image @ <https://www.christitus.com/arch-titus> -->

## Boot Arch ISO

From initial Prompt type the following commands:

### Using script
```
curl -OL mariotani25.github.io/ArchInstall/install
sh install
```

### Alternative : Manual using git
```
pacman -Sy git
git clone https://github.com/mariotani25/ArchInstall
cd ArchInstall
./archinstall.sh
```

### fixes
If you choose gnome DE and gnome terminal doesn't launch run this on tty
`echo "LANG=en_US.UTF-8" | sudo  tee /etc/locale.conf`


## System Description
This is completely automated arch install of the desktop environment on arch using all the packages I use on a daily basis. 

## Troubleshooting

__[Arch Linux Installation Guide](https://github.com/rickellis/Arch-Linux-Install-Guide)__

### No Wifi

You can check if the WiFi is blocked by running `rfkill list`.
If it says **Soft blocked: yes**, then run `rfkill unblock wifi`

After unblocking the WiFi, you can connect to it. Go through these 5 steps:

#1: Run `iwctl`

#2: Run `device list`, and find your device name.

#3: Run `station [device name] scan`

#4: Run `station [device name] get-networks`

#5: Find your network, and run `station [device name] connect [network name]`, enter your password and run `exit`. You can test if you have internet connection by running `ping google.com`, and then Press Ctrl and C to stop the ping test.

## Credits

- Original packages script was a post install cleanup script called ArchMatic located here: https://github.com/rickellis/ArchMatic
- Original packages script was a post install cleanup script called ArchTitus located here: https://github.com/ChrisTitusTech/ArchTitus
