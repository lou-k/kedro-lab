FROM ubuntu:18.04
ENV LANG C.UTF-8

# Install the tools we want from apt
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update  && \
    apt-get install -y python3.7 python3.7-dev python3-distutils-extra wget screen git psmisc rsync htop libfreeimage3 build-essential && \
    ln -s /usr/bin/python3.7 /usr/local/bin/python && \
    # Cleanup
    ldconfig && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Install Pip and python modules that we want
COPY requirements.txt /tmp/requirements.txt
RUN wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python3.7 /tmp/get-pip.py && \
    pip install -r /tmp/requirements.txt && \
    rm /tmp/*

# Makes things look cool and starts some services
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY 05-banner /etc/update-motd.d/05-banner
RUN chmod 0755 /etc/update-motd.d/05-banner && \
    chmod +x /usr/local/bin/docker-entrypoint.sh && \
    perl -p -i -e 's/#force_color_prompt=yes/force_color_prompt=yes/g' ~/.bashrc && \
    echo 'source /etc/update-motd.d/05-banner' >>  ~/.bashrc

ENTRYPOINT ["docker-entrypoint.sh"]