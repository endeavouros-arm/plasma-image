#!/bin/bash

Main() {

   desktop=" "

  # using the presence of ark to determine if KDE Plasma was a chosen Desktop Environment
  if pacman -Qq ark >/dev/null 2>&1 ; then
#     SDDM="true"
#     _disable_autologin_sddm
     pacman -Rns --noconfirm plasma-welcome
     pacman -S --noconfirm eos-plasma-sddm-config # re-install to set sddm config
  else
     pacman -Rns --noconfirm eos-plasma-sddm-config
     pacman -Rns --noconfirm spectacle
     pacman -Rns --noconfirm plasma
     pacman -Rns --noconfirm konsole dolphin kate libkate
     rm /etc/sddm.conf
  fi

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
  rm -rf /root/configs
  rm /root/config_script
  rm /root/platformname
  rm /root/type

  if pacman -Qq xfce4-session >/dev/null 2>&1 ; then
    desktop="lightdm"
    systemctl enable lightdm.service
  elif pacman -Qq i3-gaps >/dev/null 2>&1 ; then
    desktop="lightdm"
    systemctl enable lightdm.service
  elif pacman -Qq gnome-shell >/dev/null 2>&1 ; then
    desktop="gdm"
    systemctl enable gdm.service
  elif pacman -Qq mate-desktop >/dev/null 2>&1 ; then
    desktop="lightdm"
    systemctl enable lightdm.service
  elif pacman -Qq cinnamon-desktop >/dev/null 2>&1 ; then
    desktop="lightdm"
    systemctl enable lightdm.service
  elif pacman -Qq budgie-desktop >/dev/null 2>&1 ; then
    desktop="lightdm"
    systemctl enable lightdm.service
  elif pacman -Qq plasma-desktop >/dev/null 2>&1 ; then
    desktop="sddm"
    systemctl enable sddm.service
  elif pacman -Qq lxqt-session >/dev/null 2>&1 ; then
    desktop="sddm"
    systemctl enable sddm.service
  elif pacman -Qq lxde-common >/dev/null 2>&1 ; then
    desktop="lightdm"
    systemctl enable lightdm.service
  fi

  if [[ "$desktop" = "lightdm" ]] ; then
     sed -i 's/draw-grid=true/draw-grid=false/' /etc/lightdm/slick-greeter.conf
     sed -i 's/user-session=plasma/#user-session=/' /etc/lightdm/lightdm.conf
  fi

#  if [ "$LIGHTDM" = "true" ] ; then
#    rm /etc/sddm.conf.d/kde_settings.conf
#    systemctl disable sddm.service
#    systemctl enable lightdm.service
#    systemctl start lightdm.service
#  fi

#  if [ "GDM" = "true" ] ; then
#    rm /etc/sddm.conf.d/kde_settings.conf
#    systemctl disable sddm.service
#    systemctl enable gdm.service
#    systemctl start gdm.service
#  fi

#  if [ "SDDM" = "true" ] ; then
#    systemctl disable sddm.service
#    systemctl enable sddm.service
#    systemctl start sddm.service
#  fi

  systemctl enable NetworkManager
  systemctl reboot

  exit
}

Main "$@"
