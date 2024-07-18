# Bazowy obraz Ubuntu
FROM ubuntu:latest

# Informacje o utrzymaniu obrazu
LABEL maintainer="dawid.brzezinski@hotmail.com"

# Zaktualizowanie systemu i zainstalowanie pakietów
RUN apt-get update && \
    apt-get install -y \
    sudo \
    openssh-server \
    apache2 \
    net-tools \
    iproute2 \
    iputils-ping \
    dnsutils \
    traceroute \
    curl \
    wget \
    telnet \
    tcpdump \
    nmap \
    lsof \
    strace \
    vim \
    nano && \
    apt-get clean

# Utworzenie użytkownika 'dawid' z prawami roota i katalogiem domowym w /home/dawid
RUN useradd -m -d /home/dawid -s /bin/bash dawid && \
    echo 'dawid:password' | chpasswd && \
    adduser dawid sudo && \
    echo 'dawid ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Skonfigurowanie serwera SSH
RUN mkdir /var/run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Otworzenie portów 22 dla SSH oraz 80 dla Apache
EXPOSE 22 80

# Skopiowanie plików WWW z lokalnego hosta do kontenera
COPY ./www /var/www/html

# Uruchomienie serwera Apache i SSH
CMD service apache2 start && /usr/sbin/sshd -D
