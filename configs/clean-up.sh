#!/bin/bash

## Function to remove calamares plasma environment packages

_remove_packages_plasma () {
    pacman -Rns --noconfirm eos-plasma-sddm-config
    pacman -Rns --noconfirm spectacle
    pacman -Rns --noconfirm plasma
    pacman -Rns --noconfirm konsole dolphin kate
}

_disable_autologin_sddm () {
    sed -i 's/Session=plasma/Session=/' /etc/sddm.conf.d/kde_settings.conf
    sed -i 's/User=alarm/User=/' /etc/sddm.conf.d/kde_settings.conf
}

Main() {

  LIGHTDM=false
  GDM=false
  SDDM=false

  cp /home/alarm/endeavour-install.log /tmp/
  sed -i 's/alarm ALL=(ALL:ALL) NOPASSWD: ALL/ /g' /etc/sudoers
  userdel -rf alarm
  newname=$(cat /etc/passwd | grep 1001 | awk -F':' '{print $1}')
  rm /home/$newname/.Xauthority
  usermod -u 1000 $newname
  groupmod -g 1000 $newname
  chown -R $newname:$newname /home/$newname
  cp /tmp/endeavour-install.log /home/$newname/endeavour-install.log
  chown $newname:$newname /home/$newname/endeavour-install.log

  pacman -Rns --noconfirm calamares
  rm -rf /etc/calamares/
  rm /usr/local/bin/clean-up.sh
  rm /usr/local/bin/resize-fs.sh
  rm /etc/systemd/system/multi-user.target.wants/clean-up.service
  # restore getty@.service
  mv /usr/lib/systemd/system/getty@.service.bak /usr/lib/systemd/system/getty@.service
#  rm /usr/lib/systemd/system/getty@.service.bak
#  printf "export DISPLAY=':0'\nxhost +SI:localuser:alarm\nxhost +SI:localuser:root\nexec plasma\n" >> /home/$newname/.xinitrc
  rm -rf /root/configs
  rm /root/config_script
  rm /root/platformname
  rm /root/type

  # using the presence of ark to determine if KDE Plasma was a chosen Desktop Environment
  if pacman -Qq ark >/dev/null 2>&1 ; then
     SDDM=true
     _disable_autologin_sddm
     pacman -Rns --noconfirm plasma-welcome
     pacman -S --noconfirm eos-plasma-sddm-config # re-install to set sddm config
  else
     _remove_packages_plasma
  fi

  if pacman -Qq xfce4-session >/dev/null 2>&1 ; then
    LIGHTDM=true
  elif pacman -Qq i3-gaps >/dev/null 2>&1 ; then
    LIGHTDM=true
  elif pacman -Qq gnome-shell >/dev/null 2>&1 ; then
    GDM=true
  elif pacman -Qq mate-desktop >/dev/null 2>&1 ; then
    LIGHTDM=true
  elif pacman -Qq cinnamon-desktop >/dev/null 2>&1 ; then
    LIGHTDM=true
  elif pacman -Qq budgie-desktop >/dev/null 2>&1 ; then
    LIGHTDM=true
  elif pacman -Qq lxqt-session >/dev/null 2>&1 ; then
    SDDM=true
  elif pacman -Qq lxde-common >/dev/null 2>&1 ; then
    LIGHTDM=true
  fi


  if [ "LIGHTDM" = "true" ] ; then
    systemctl -f enable lightdm.service
  fi

  if [ "GDM" = "true" ] ; then
    systemctl -f enable gdm.service
  fi

  if [ "SDDM" = "true" ] ; then
    systemctl -f enable sddm.service
  fi

  systemctl daemon-reload

  exit
}

Main "$@"
