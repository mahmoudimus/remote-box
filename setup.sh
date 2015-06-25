#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

RESOLUTION=${1:-"2048x1280x24"}
USERNAME=${2:-"mahmoud"}


function setup_user() {
    useradd -m -d /home/${USERNAME} -s /bin/bash ${USERNAME}
    usermod -a -G admin ${USERNAME}
    passwd ${USERNAME}
}


function install_nomachine() {
    wget http://download.nomachine.com/download/4.6/Linux/nomachine_4.6.4_13_amd64.deb
    dpkg -i nomachine_4.6.4_13_amd64.deb
    echo 'DefaultDesktopCommand "/usr/bin/X11/startxfce4"' >> /usr/NX/etc/server.cfg
    echo "PhysicalDesktopAuthorization 0" >> /usr/NX/etc/server.cfg
    echo "VirtualDesktopAuthorization 0"  >> /usr/NX/etc/server.cfg
    service nxserver restart
    /usr/NX/bin/nxserver --install --setup-nomachine-key
    /usr/NX/bin/nxserver --useradd ${USERNAME}
}


function install_intellij() {
    wget http://download.jetbrains.com/idea/ideaIU-14.1.4.tar.gz
    mv ideaIU-14.1.4.tar.gz intellij-idea.tar.gz
    tar xzvf intellij-idea.tar.gz
}


function main() {
    # setup java
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true \
        | debconf-set-selections
    add-apt-repository -y ppa:webupd8team/java

    apt-get -qq update
    apt-get install -y oracle-java8-installer xfce4 xvfb

    COOKIE=`ps -ef | md5sum | cut -f 1 -d " "`
    AUTHFILE=$HOME/Xvfb-0.auth
    xauth add :0 MIT-MAGIC-COOKIE-1 $COOKIE
    # or custom resolution
    Xvfb :0 -auth $AUTHFILE -screen 0 ${RESOLUTION} &
    DISPLAY=:0 nohup /etc/X11/Xsession startxfce4 &

    setup_user()
    install_nomachine()
    install_intellij()
}

main
if [ $? -neq 0 ]; then
    echo "install failed. try again."
    exit -1
fi

cd intellij-idea
JAVA_HOME/usr/lib/jvm/java-8-oracle ./bin/idea.sh
