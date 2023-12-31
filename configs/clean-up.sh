#!/bin/bash

Main() {

  # using the presence of ark to determine if KDE Plasma was a chosen Desktop Environment
  if pacman -Qq ark >/dev/null 2>&1 ; then
     pacman -Rns --noconfirm plasma-welcome
     pacman -S --noconfirm eos-plasma-sddm-config # re-install to set sddm config
     if pacman -Qq linux-rockchip-rk3588 >/dev/null 2>&1 ; then
        pacman -R --noconfirm plasma-wayland-session
     elif pacman -Qq linux-rpi >/dev/null 2>&1 ; then
        pacman -R --noconfirm plasma-wayland-session
     elif pacman -Qq linux-rpi-16k >/dev/null 2>&1 ; then
        pacman -R --noconfirm plasma-wayland-session
     fi
  else
     pacman -Rns --noconfirm eos-plasma-sddm-config
     pacman -Rns --noconfirm spectacle
     pacman -Rns --noconfirm plasma
     pacman -Rns --noconfirm konsole
     pacman -Rns --noconfirm dolphin
     pacman -Rns --noconfirm kate
     pacman -Rns --noconfirm libkate
     pacman -Rns --noconfirm kdeclarative5
     pacman -Rns --noconfirm kded5
     rm /etc/sddm.conf
  fi

  cp /home/alarm/endeavour-install.log /var/log/endeavour-install.log
  sed -i 's/alarm ALL=(ALL:ALL) NOPASSWD: ALL/ /g' /etc/sudoers
  userdel -rf alarm
  newname=$(cat /etc/passwd | grep 1001 | awk -F':' '{print $1}')
  usermod -u 1000 $newname
  groupmod -g 1000 $newname
  chown -R $newname:$newname /home/$newname
  rm /home/$newname/.Xauthority
  cp /var/log/endeavour-install.log /home/$newname/endeavour-install.log
  chown $newname:$newname /home/$newname/endeavour-install.log
  if pacman -Qq ark >/dev/null 2>&1 ; then
     printf "\n[Wallet]\nEnabled=false\n" > /home/$newname/.config/kwalletrc
  fi
  pacman -Rns --noconfirm calamares
  rm -rf /etc/calamares/
  rm /usr/local/bin/clean-up.sh
  rm /usr/local/bin/resize-fs.sh
  rm /etc/systemd/system/multi-user.target.wants/clean-up.service
  rm /etc/systemd/system/clean-up.service
  # restore getty@.service
  mv /usr/lib/systemd/system/getty@.service.bak /usr/lib/systemd/system/getty@.service
  rm -rf /root/configs
  rm /root/config_script
  rm /root/platformname
  rm /root/type

  if pacman -Qq lightdm >/dev/null 2>&1 ; then
     sed -i 's/draw-grid=true/draw-grid=false/' /etc/lightdm/slick-greeter.conf
     sed -i 's/user-session=plasma/#user-session=/' /etc/lightdm/lightdm.conf
  fi

  exit
}

Main "$@"
