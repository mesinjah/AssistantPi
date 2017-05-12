#!/bin/bash
echo ""
echo "Starting Assistant SDK Installation..."
echo "######################################################################################################"
echo "-- You can start this step manually if it fails by typing   sudo bash /opt/AlexaPi/src/scripts/install_assistant.sh"
echo ""
# Prequisiteries
echo "## Installing dependencies..."
apt-get install python3 python3-dev python3-venv -y
apt-get install portaudio19-dev libffi-dev libssl-dev -y

# Setup Virtual Environment
echo "## Setting up Virtual Environment"
sudo python3 -m venv /opt/AlexaPi/env
if [ -d "/opt/AlexaPi/env" ]; then
    # Will enter here if Directory exists
    /opt/AlexaPi/env/bin/pip install pip setuptools --upgrade

	# Install forked Assistant SDK
	echo "## Installing forked Assistant SDK"
	cd /opt/AlexaPi/src
	sudo rm -rf assistant-sdk-python
	sudo git clone https://github.com/xtools-at/assistant-sdk-python.git
	cd /opt/AlexaPi/src/assistant-sdk-python
	/opt/AlexaPi/env/bin/python -m pip install --upgrade -e ".[samples]"
	/opt/AlexaPi/env/bin/pip install tenacity

	echo "## Copying default sound config from /opt/AlexaPi/src/assistant.asound.conf to /etc/asound.conf"
	echo "See here for more information: https://developers.google.com/assistant/sdk/prototype/getting-started-pi-python/configure-audio"
	# Put default Sound config in place
	{sudo mv /etc/asound.conf /etc/asound.conf.bkp} || {}
	sudo cp /opt/AlexaPi/src/assistant.asound.conf /etc/asound.conf
	sudo ln -sf /etc/asound.conf /home/pi/.asoundrc

	echo ""
	echo "## Auhentication with Google API"
	echo "You can start this step manually by typing   sudo bash /opt/AlexaPi/src/scripts/auth_assistant.sh"
	read -r -p "Start Authentication with Google API now? [Y/n]: " start_auth
	case $start_auth in
	    [Nn] )
		;;
	    * )
			sudo bash /opt/AlexaPi/src/scripts/auth_assistant.sh
		;;
	esac
else
	echo ""
	echo "-- Creating Python virtual environment for Assistant SDK failed. Please run this manually:"
	echo "sudo python3 -m venv /opt/AlexaPi/env"
	echo "-- Check if folder  /opt/AlexaPi/env  has been created"
	echo "-- and restart the installer with  sudo bash /opt/AlexaPi/src/scripts/install_assistant.sh"
	echo ""
	echo "Exiting..."
	exit
fi
