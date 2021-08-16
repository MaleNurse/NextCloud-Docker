FROM nextcloud

SHELL ["/bin/bash", "-c"]
USER root
RUN apt-get update
RUN apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata
RUN apt-get install -y git wget sudo pkg-config curl apt-utils vim nano python3 python3-pip python3-setuptools autoconf libssl-dev ffmpeg aria2 software-properties-common rpcbind daemon
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN mkdir -p /var/log/aria2c /var/local/aria2c
RUN touch /var/local/aria2c/aria2c.sess
RUN chown www-data.www-data -R /var/log/aria2c /var/local/aria2c
RUN chmod 770 -R /var/log/aria2c /var/local/aria2c
RUN sudo -u www-data aria2c --enable-rpc --rpc-allow-origin-all -c -D --log=/var/log/aria2c/aria2c.log --check-certificate=false --save-session=/var/local/aria2c/aria2c.session --dht-file-path=/etc/aria2/dht.dat --save-session-interval=2 --continue=true --input-file=/var/local/aria2c/aria2c.session --rpc-save-upload-metadata=true --force-save=true --log-level=warn --rpc-secret=Dyj323jaz605
RUN pip install youtube-dl
RUN mkdir /.cache
RUN chmod 777 /.cache
RUN usermod -u 1000 www-data
RUN usermod -aG sudo www-data
RUN groupmod -g 998 www-data
RUN sed -i '188isudo -u www-data aria2c --daemon --enable-rpc=true' /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh", "apache2-foreground"]
