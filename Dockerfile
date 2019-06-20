FROM  	ubuntu:16.04

LABEL 	maintainer="rashed.sarwar@ukaea.uk"

ENV 	DEBIAN_FRONTEND=noninteractive
ENV 	LC_ALL=en_US.UTF-8 
ENV 	LANG=en_US.UTF-8 
ENV 	LANGUAGE=en_US.UTF-8 

ARG 	user=plnx

RUN 	adduser --disabled-password --gecos '' $user

RUN 	mkdir -p /opt/Xilinx /home/$user/workspace

RUN 	chown -R $user:$user /opt/Xilinx /home/$user/workspace

# using UK mirror to speed up
COPY 	sources.list /etc/apt/sources.list

RUN 	dpkg --add-architecture i386 	&& \
    	apt-get update -y 		&& \
    	apt-get clean all 		&& \
    	apt-get install -y -qq iputils-ping sudo rsync apt-utils x11-utils

# Required tools and libraries of Petalinux.
# See in: ug1144-petalinux-tools-reference-guide, 2018.2
RUN 	apt-get install -y  --no-install-recommends \
	tofrodos iproute2 gawk xvfb gcc-4.8 wget build-essential \
	checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev \
	libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev git make \
	net-tools libncurses5-dev zlib1g-dev libssl-dev flex bison \
	libselinux1 gnupg diffstat chrpath socat xterm autoconf libtool \
	tar unzip texinfo gcc-multilib libsdl1.2-dev libglib2.0-dev \
	screen pax gzip language-pack-en libtool-bin cpio lib32z1 lsb-release \
	zlib1g:i386 vim-common libgtk2.0-dev libstdc++6:i386 libc6:i386 
	# Using expect to install Petalinux automatically.
RUN apt-get install -y expect vim
# bash is PetaLinux recommended shell
RUN 	ln -fs /bin/bash /bin/sh    

RUN 	echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
#RUN 	echo "nouserlogin ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
#RUN   sudo groupadd -g 999 nouserlogin
RUN 	echo "source ~/env.sh" >> /etc/skel/.bashrc
RUN 	echo "source /opt/Xilinx/PetaLinux/\$pVERSION/settings.sh" >> /etc/skel/.bashrc
RUN 	echo "source /opt/Xilinx/PetaLinux/\$pVERSION/components/yocto/source/\$ARCH/environment-*" >> /etc/skel/.bashrc
RUN   usermod -a -G sudo $user
#RUN   usermod -a -G nouserlogin $user
RUN   chmod +w /etc/sudoers 
USER 	$user

RUN   echo "sudo groupadd -g \${GROUP_ID} \${USER_NAME}" >> /home/$user/.bashrc 
RUN   echo "sudo adduser --no-create-home --disabled-password --gecos '' --shell /bin/bash -u=\${USER_ID} -gid \${GROUP_ID} \${USER_NAME}" >> /home/$user/.bashrc
RUN   echo "echo \"\${USER_NAME}:password\" | sudo chpasswd" >> /home/$user/.bashrc
#RUN   echo "sudo usermod -a -G nouserlogin \${USER_NAME}" >> /home/$user/.bashrc
RUN   echo "sudo usermod -a -G sudo \${USER_NAME}" >> /home/$user/.bashrc
RUN   echo "sudo cp /etc/skel/.* /home/\${USER_NAME}/." >> /home/$user/.bashrc 
RUN   echo "touch /home/$user/env.sh" >> /home/$user/.bashrc 
RUN   echo "echo \"export pVERSION=\${pVERSION}\" >> /home/$user/env.sh" >> /home/$user/.bashrc 
RUN   echo "echo \"export ARCH=\${ARCH} \" >> /home/$user/env.sh" >> /home/$user/.bashrc
RUN   echo "echo \"export PWD=\${PWD} \" >> /home/$user/env.sh" >> /home/$user/.bashrc
RUN   echo "sudo mv /home/$user/env.sh /home/\${USER_NAME}/." >> /home/$user/.bashrc 
RUN 	echo "sudo chown -R \${USER_NAME}:\${USER_NAME} /home/\${USER_NAME}" >> /home/$user/.bashrc 
RUN 	echo "sudo su - \${USER_NAME}" >> /home/$user/.bashrc 
#RUN 	echo "source /opt/Xilinx/PetaLinux/\$pVERSION/settings.sh" >> /home/$user/.bashrc
#RUN 	echo "source /opt/Xilinx/PetaLinux/\$pVERSION/components/yocto/source/\$ARCH/environment-*" >> /home/$user/.bashrc
#RUN   echo "su ${USER_NAME}" 

WORKDIR /home/$user/workspace


