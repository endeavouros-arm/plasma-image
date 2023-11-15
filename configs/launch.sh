#!/bin/bash

source /usr/share/endeavouros/scripts/eos-script-lib-yad

calamares-official() {
    sudo cp /home/alarm/configs/calamares/settings_online.conf /etc/calamares/settings.conf
    sudo -E calamares -D 8 >> /home/alarm/endeavour-install.log
}
export -f calamares-official

edit-mirrors() {
    konsole -e "sudo nano /etc/pacman.d/mirrorlist"
}
export -f edit-mirrors

yad --title "EndeavourOS ARM Installer" --form --fixed --width=460 --height=370 --center --borders=40 --buttons-layout=center --window-icon=/usr/share/endeavouros/endeavouros-dark.png --button=yad-cancel:1 \
--text="<b>                            EndeavourOS ARM Installer:</b>

             Ensure that you are connected to the internet
             before proceeding to the Calamares installer.

             Network connection options are available in the
             system tray on the bottom right of your screen.

             WiFi only users will need to choose a network
             and enter a password.
" \
--field="<b>Install EndeavourOS ARM</b>":fbtn "bash -c calamares-official" \
--field="<b>Edit Archlinux ARM Mirrorlist</b>":fbtn "bash -c edit-mirrors"
