#!/bin/sh

# LINUX LIVE SETUP SCRIPT V1.2
#
# Firewall setup
# Environment config
#



# check OS
OS=$(cat /etc/issue | awk '{print $1, $2}' | sed -e 's/^[ \t]*//')

# check chassis
CHASSIS=$(hostnamectl status | grep Chassis | cut -f2 -d ":" | tr -d ' ')

# cinnamon dark theme
CINNAMONDARKTHEME=$(cat <<EOF
#!/usr/bin/python3
from gi.repository import Gio
settings = Gio.Settings(schema="org.cinnamon.desktop.interface")
settings.set_string("gtk-theme", "Mint-Y-Dark")
settings.set_string("icon-theme", "Mint-Y-Dark")
Gio.Settings(schema="org.cinnamon.desktop.wm.preferences").set_string("theme", "Mint-Y")
Gio.Settings(schema="org.cinnamon.theme").set_string("name", "Mint-Y-Dark")
EOF
)


# firewall setup
echo "\nFirewall setup...\n" &&
sudo ufw enable &&
sudo ufw default deny incoming &&
sudo ufw default allow outgoing &&
sudo ufw reload &&
sudo ufw status verbose



# environment setup
echo "\nEnvironment config for OS: ${OS}..."

case "$OS" in
	"Peppermint Ten")
		echo "Xfce4 panel configuration..."

		## remove videos
		xfconf-query -c xfce4-panel -p /plugins/plugin-5 -rR &&

		## remove pager
		xfconf-query -c xfwm4 -p /general/workspace_count -s 1 &&
		xfconf-query -c xfce4-panel -p /plugins/plugin-8 -rR &&

		## remove power manager icon, if not laptop
		if ! [ "$CHASSIS" = "laptop" ]; then
			xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/show-tray-icon -s 0
		fi;

		## keyboard layout config
		xfconf-query -n -c xfce4-panel -p "/plugins/plugin-11/display-type" -t uint -s "2" &&
		xfconf-query -n -c xfce4-panel -p "/plugins/plugin-11/display-name" -t uint -s "1" &&
		xfconf-query -n -c xfce4-panel -p "/plugins/plugin-11/display-tooltip-icon" -t bool -s "false" &&
		xfconf-query -n -c xfce4-panel -p "/plugins/plugin-11/group-policy" -t uint -s "0" &&

		## clock config & timezone
		xfconf-query -n -c xfce4-panel -p "/plugins/plugin-12/digital-format" -t string -s "%H:%M %a %d/%m/%Y" &&
		sudo timedatectl set-timezone Europe/Copenhagen &&

		## restart xfce4 panel
		echo "Restarting XFCE4 panel..." &&
		xfce4-panel -r
		;;

	"Linux Mint")
		echo "Cinnamon panel configuration..."
		
		## set timezone
		sudo timedatectl set-timezone Europe/Copenhagen &&
		
		## cinnamon dark theme
		python3 -c "$CINNAMONDARKTHEME"
		
		## config panels
		dconf write /org/cinnamon/panels-enabled "['1:0:bottom', '2:1:bottom', '3:2:bottom']" &&
		dconf write /org/cinnamon/panels-height "['1:24', '2:24', '3:24']" &&
		dconf write /org/cinnamon/panel-zone-icon-sizes '[{"left":0,"center":0,"right":0,"panelId":1}, {"left":0,"center":0,"right":0,"panelId":2}, {"left":0,"center":0,"right":0,"panelId":3}]' &&
		
		## set panel icons
		if ! [ "$CHASSIS" = "laptop" ]; then
			dconf write /org/cinnamon/enabled-applets "['panel1:left:0:menu@cinnamon.org','panel1:left:1:panel-launchers@cinnamon.org','panel1:left:2:window-list@cinnamon.org','panel1:right:0:systray@cinnamon.org','panel1:right:1:xapp-status@cinnamon.org','panel1:right:2:keyboard@cinnamon.org','panel1:right:3:notifications@cinnamon.org','panel1:right:4:printers@cinnamon.org','panel1:right:5:removable-drives@cinnamon.org','panel1:right:6:network@cinnamon.org','panel1:right:7:sound@cinnamon.org','panel1:right:8:calendar@cinnamon.org','panel2:left:0:menu@cinnamon.org','panel2:left:1:panel-launchers@cinnamon.org','panel2:left:2:window-list@cinnamon.org','panel2:right:0:systray@cinnamon.org','panel2:right:1:xapp-status@cinnamon.org','panel2:right:2:keyboard@cinnamon.org','panel2:right:3:notifications@cinnamon.org','panel2:right:4:printers@cinnamon.org','panel2:right:5:removable-drives@cinnamon.org','panel2:right:6:network@cinnamon.org','panel2:right:7:sound@cinnamon.org','panel2:right:8:calendar@cinnamon.org', 'panel3:left:0:menu@cinnamon.org','panel3:left:1:panel-launchers@cinnamon.org','panel3:left:2:window-list@cinnamon.org','panel3:right:0:systray@cinnamon.org','panel3:right:1:xapp-status@cinnamon.org','panel3:right:2:keyboard@cinnamon.org','panel3:right:3:notifications@cinnamon.org','panel3:right:4:printers@cinnamon.org','panel3:right:5:removable-drives@cinnamon.org','panel3:right:6:network@cinnamon.org','panel3:right:7:sound@cinnamon.org','panel3:right:8:calendar@cinnamon.org']"
		else
			dconf write /org/cinnamon/enabled-applets "['panel1:left:0:menu@cinnamon.org','panel1:left:1:panel-launchers@cinnamon.org','panel1:left:2:window-list@cinnamon.org','panel1:right:0:systray@cinnamon.org','panel1:right:1:xapp-status@cinnamon.org','panel1:right:2:keyboard@cinnamon.org','panel1:right:3:notifications@cinnamon.org','panel1:right:4:printers@cinnamon.org','panel1:right:5:removable-drives@cinnamon.org','panel1:right:6:network@cinnamon.org','panel1:right:7:sound@cinnamon.org','panel1:right:8:power@cinnamon.org','panel1:right:9:calendar@cinnamon.org','panel2:left:0:menu@cinnamon.org','panel2:left:1:panel-launchers@cinnamon.org','panel2:left:2:window-list@cinnamon.org','panel2:right:0:systray@cinnamon.org','panel2:right:1:xapp-status@cinnamon.org','panel2:right:2:keyboard@cinnamon.org','panel2:right:3:notifications@cinnamon.org','panel2:right:4:printers@cinnamon.org','panel2:right:5:removable-drives@cinnamon.org','panel2:right:6:network@cinnamon.org','panel2:right:7:sound@cinnamon.org','panel2:right:8:power@cinnamon.org','panel2:right:9:calendar@cinnamon.org', 'panel3:left:0:menu@cinnamon.org','panel3:left:1:panel-launchers@cinnamon.org','panel3:left:2:window-list@cinnamon.org','panel3:right:0:systray@cinnamon.org','panel3:right:1:xapp-status@cinnamon.org','panel3:right:2:keyboard@cinnamon.org','panel3:right:3:notifications@cinnamon.org','panel3:right:4:printers@cinnamon.org','panel3:right:5:removable-drives@cinnamon.org','panel3:right:6:network@cinnamon.org','panel3:right:7:sound@cinnamon.org','panel3:right:8:power@cinnamon.org','panel3:right:9:calendar@cinnamon.org']"
		fi;

		cinnamon --replace > /dev/null 2>&1 & disown
		;;
esac



# clear
clear
