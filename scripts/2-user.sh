#!/usr/bin/env bash
echo -ne "
-------------------------------------------------------------------------
                    Automated Arch Linux Installer
                        SCRIPTHOME: ArchInstall
-------------------------------------------------------------------------

Installing AUR Softwares
"
source $HOME/ArchInstall/configs/setup.conf

  cd ~
  mkdir "$HOME/.cache"
  touch "$HOME/.cache/zshhistory"
  git clone "https://github.com/ChrisTitusTech/zsh"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  ln -s "$HOME/zsh/.zshrc" ~/.zshrc
  # chsh -s /usr/bin/zsh $USERNAME

sed -n '/'$INSTALL_TYPE'/q;p' ~/ArchInstall/pkg-files/${DESKTOP_ENV}.txt | while read line
do
  if [[ ${line} == '--END OF MINIMAL INSTALL--' ]]
  then
    # If selected installation type is FULL, skip the --END OF THE MINIMAL INSTALLATION-- line
    continue
  fi
  echo "INSTALLING: ${line}"
  sudo pacman -S --noconfirm --needed --color=always ${line}
done


if [[ ! $AUR_HELPER == none ]]; then
  cd ~
  git clone "https://aur.archlinux.org/$AUR_HELPER.git"
  cd ~/$AUR_HELPER
  makepkg -si --noconfirm
  # sed $INSTALL_TYPE is using install type to check for MINIMAL installation, if it's true, stop
  # stop the script and move on, not installing any more packages below that line
  sed -n '/'$INSTALL_TYPE'/q;p' ~/ArchInstall/pkg-files/aur-pkgs.txt | while read line
  do
    if [[ ${line} == '--END OF MINIMAL INSTALL--' ]]; then
      # If selected installation type is FULL, skip the --END OF THE MINIMAL INSTALLATION-- line
      continue
    fi
    echo "INSTALLING: ${line}"
    $AUR_HELPER -S --noconfirm --needed --color=always ${line}
  done
fi

export PATH=$PATH:~/.local/bin

# Theming DE if user chose FULL installation
if [[ $INSTALL_TYPE == "FULL" ]]; then
cp -rf ~/ArchInstall/configs/.config/* ~/.config
  if [[ $DESKTOP_ENV == "kde" ]]; then
    $AUR_HELPER -S --noconfirm --needed --color=always sddm-nordic-theme-git
    tar -xvf $HOME/ArchInstall/configs/kde-config/local-kde.tar.gz -C $HOME/ArchInstall/configs/kde-config/
    sleep 1
    mkdir -p ~/.local/share
    cp -rf ~/ArchInstall/configs/kde-config/.local/share/* ~/.local/share
    # cp -rf ~/ArchInstall/configs/.config/* ~/.config
    ### Konsave
    pip install konsave
    python -m konsave -i ~/ArchInstall/configs/kde-config/kde.knsv
    sleep 1
    python -m konsave -a kde
    sleep 1
  elif [[ $DESKTOP_ENV == "xfce" ]]; then
    $AUR_HELPER -S --noconfirm --needed --color=always nordic-theme nordic-darker-theme
  fi
  elif [[ $DESKTOP_ENV == "openbox" ]]; then
    cd ~
    git clone https://github.com/stojshic/dotfiles-openbox
    ./dotfiles-openbox/install-titus.sh
  fi
fi

echo -ne "
-------------------------------------------------------------------------
                    SYSTEM READY FOR 3-post-setup.sh
-------------------------------------------------------------------------
"
exit
