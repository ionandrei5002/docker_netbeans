FROM ubuntu:16.04

RUN apt update && \
	apt install -y --no-install-recommends software-properties-common wget dbus aptitude nano maven libmaven3-core-java && \
	add-apt-repository ppa:webupd8team/java -y && \
	apt update && \
	echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt install -y --no-install-recommends oracle-java8-installer libxext-dev libxrender-dev libxtst-dev && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN groupadd -r andrei -g 1000 && \
	useradd -u 1000 -d /home/andrei -r -g andrei andrei && \
	mkdir -p /home/andrei && \
	echo "andrei:x:1000:1000:andrei,,,:/home/andrei:/bin/bash" >> /etc/passwd && \
	echo "andrei:x:1000:" >> /etc/group && \
	mkdir -p /etc/sudoers.d && \
	echo "andrei ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/andrei && \
	chmod 0440 /etc/sudoers.d/andrei && \
	chown 1000:1000 -R /home/andrei && \
	chmod 777 -R /home/andrei && \
	dbus-uuidgen > /var/lib/dbus/machine-id

RUN echo 'root:admin' | chpasswd

RUN wget http://download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-linux.sh -O /tmp/netbeans.sh -q && \
	chmod +x /tmp/netbeans.sh && \
    echo 'Installing netbeans'

USER andrei
ENV HOME /home/andrei
WORKDIR /home/andrei

ENV DEBIAN_FRONTEND noninteractive
RUN /tmp/netbeans.sh --verbose --silent -J-Dnb-base.jdk.location=/usr/lib/jvm/java-8-oracle
#RUN /tmp/netbeans.sh --verbose --silent --state /tmp/state.xml

RUN echo 'netbeans_default_options="-J-client -J-Xss2m -J-Xms32m -J-Dapple.laf.useScreenMenuBar=true -J-Dapple.awt.graphics.UseQuartz=true -J-Dsun.java2d.noddraw=true -J-Dsun.java2d.dpiaware=true -J-Dsun.zip.disableMemoryMapping=true -J-Dswing.aatext=true -J-Dawt.useSystemAAFontSettings=on"' >> /home/andrei/netbeans-8.2/etc/netbeans.conf

USER root
RUN rm -rf /tmp/*

USER andrei