FROM ubuntu:bionic

# General packages
WORKDIR /
RUN dpkg --add-architecture i386
RUN apt update && apt upgrade
RUN DEBIAN_FRONTEND="noninteractive" apt install -y gdb gdbserver gcc gcc-multilib \
                    python3 python3-pip python python-pip vim \
                    libseccomp-dev libseccomp-dev:i386 \
                    binutils binwalk curl wget netcat locales \
                    ruby clang llvm git radare2 tmux \
					manpages-posix manpages-dev man-db

# Misc Langs and GEF
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install ropper capstone keystone-engine pwntools
RUN gem install one_gadget

# Install GEF
RUN wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh

# Install pwndbg
#RUN git clone https://github.com/pwndbg/pwndbg && cd pwndbg && ./setup.sh

# Chaning locale for GEF
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 
RUN echo 'export PS1="\e[0;36m\u@\h \w> \e[m"' >> /root/.bash_profile

USER root
CMD ["/bin/bash", "-l"]
