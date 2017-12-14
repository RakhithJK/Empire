#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo " [!]This script must be run as root" 1>&2
   exit 1
fi

IFS='/' read -a array <<< pwd

if [[ "$(pwd)" != *setup ]]
then
    cd ./setup
fi

if [[ ! -f get-pip.py ]]
then
   wget https://bootstrap.pypa.io/get-pip.py
   python get-pip.py
fi

version=$( lsb_release -r | grep -oP "[0-9]+" | head -1 )
if lsb_release -d | grep -q "Fedora"; then
	Release=Fedora
	dnf install -y make g++ python-devel m2crypto python-m2ext swig python-iptools python3-iptools libxml2-devel default-jdk openssl-devel libssl1.0.0 libssl-dev
	pip install --upgrade urllib3
	pip install setuptools
	pip install pycrypto
	pip install iptools
	pip install pydispatcher
	pip install flask
	pip install macholib
	pip install dropbox
	pip install pyopenssl
	pip install pyinstaller
	pip install zlib_wrapper
	pip install netifaces
	pip install jinja2
elif lsb_release -d | grep -q "Kali"; then
	Release=Kali
    if ! grep "deb http://security.debian.org/debian-security wheezy/updates main" /etc/apt/sources.list; then
      echo "deb http://security.debian.org/debian-security wheezy/updates main" >> /etc/apt/sources.list
    fi
    apt-get update
	apt-get install -y make g++ python-dev python-m2crypto swig python-pip libxml2-dev default-jdk libssl1.0.0 libssl-dev
	pip install --upgrade urllib3
	pip install setuptools
	pip install pycrypto
	pip install iptools
	pip install pydispatcher
	pip install flask
	pip install macholib
	pip install dropbox
	pip install pyopenssl
	pip install pyinstaller
	pip install zlib_wrapper
	pip install netifaces
	pip install jinja2
        if [ ! which powershell > /dev/null ] && [ ! which pwsh > /dev/null ]; then
            curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
            curl https://packages.microsoft.com/config/ubuntu/14.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list
            apt-get update
        fi
        apt-get install -y powershell
        if ls /opt/microsoft/powershell/*/DELETE_ME_TO_DISABLE_CONSOLEHOST_TELEMETRY; then
            rm /opt/microsoft/powershell/*/DELETE_ME_TO_DISABLE_CONSOLEHOST_TELEMETRY
        fi
        mkdir -p /usr/local/share/powershell/Modules
        cp -r ../lib/powershell/Invoke-Obfuscation /usr/local/share/powershell/Modules
elif lsb_release -d | grep -q "Ubuntu"; then
	Release=Ubuntu
	apt-get install -y make g++ python-dev python-m2crypto swig python-pip libxml2-dev default-jdk libssl1.0.0 libssl-dev
	pip install --upgrade urllib3
	pip install setuptools
	pip install pycrypto
	pip install iptools
	pip install pydispatcher
	pip install flask
	pip install pyOpenSSL
	pip install macholib
	pip install dropbox
	pip install pyopenssl
	pip install pyinstaller
	pip install zlib_wrapper
	pip install netifaces
	pip install jinja2
        if [ ! which powershell > /dev/null ] && [ ! which pwsh > /dev/null ]; then
            curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
            if lsb_release -r | grep -q "14.04"; then
                curl https://packages.microsoft.com/config/ubuntu/14.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list
            elif lsb_release -r | grep -q "16.04"; then
                curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list
            fi
            apt-get update
        fi
        apt-get install -y powershell
        if ls /opt/microsoft/powershell/*/DELETE_ME_TO_DISABLE_CONSOLEHOST_TELEMETRY; then
            rm /opt/microsoft/powershell/*/DELETE_ME_TO_DISABLE_CONSOLEHOST_TELEMETRY
        fi
        mkdir -p /usr/local/share/powershell/Modules
        cp -r ../lib/powershell/Invoke-Obfuscation /usr/local/share/powershell/Modules
else
	echo "Unknown distro - Debian/Ubuntu Fallback"
	 apt-get install -y make g++ python-dev python-m2crypto swig python-pip libxml2-dev default-jdk libffi-dev libssl1.0.0 libssl-dev
	 pip install --upgrade urllib3
	 pip install setuptools
	 pip install pycrypto
	 pip install iptools
	 pip install pydispatcher
	 pip install flask
	 pip install macholib
	 pip install dropbox
	 pip install cryptography
	 pip install pyOpenSSL
	 pip install pyopenssl
	 pip install zlib_wrapper
	 pip install netifaces
	 pip install M2Crypto
	 pip install jinja2
         if [ ! which powershell > /dev/null ] && [ ! which pwsh > /dev/null ]; then
             curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
             curl https://packages.microsoft.com/config/ubuntu/14.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list
             apt-get update
         fi
         apt-get install -y powershell
         if ls /opt/microsoft/powershell/*/DELETE_ME_TO_DISABLE_CONSOLEHOST_TELEMETRY; then
             rm /opt/microsoft/powershell/*/DELETE_ME_TO_DISABLE_CONSOLEHOST_TELEMETRY
         fi
         mkdir -p /usr/local/share/powershell/Modules
         cp -r ../lib/powershell/Invoke-Obfuscation /usr/local/share/powershell/Modules
fi
tar -xvf ../data/misc/xar-1.5.2.tar.gz
(cd xar-1.5.2 && ./configure)
(cd xar-1.5.2 && make)
(cd xar-1.5.2 && make install)
git clone https://github.com/hogliux/bomutils.git
(cd bomutils && make)
(cd bomutils && make install)
chmod 755 bomutils/build/bin/mkbom && cp bomutils/build/bin/mkbom /usr/local/bin/mkbom
# set up the database schema
./setup_database.py

# generate a cert
./cert.sh

cd ..

echo -e '\n [*] Setup complete!\n'
