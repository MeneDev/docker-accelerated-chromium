FROM ubuntu:16.04

LABEL maintainer="Tomohisa Kusano <siomiz@gmail.com>"

COPY copyables /

ADD https://dl.google.com/linux/linux_signing_key.pub /tmp/

RUN apt-get update
RUN apt-get install -y \
	fonts-takao \
	pulseaudio \
	&& apt-get clean \
	&& rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/* /tmp/* \
	&& useradd -m -G pulse-access chrome \
	&& usermod -s /bin/bash chrome

RUN apt-get update -y
RUN apt-get install \
      curl \
      wget \
      supervisor \
      software-properties-common \
      -y

RUN add-apt-repository ppa:saiarcot895/chromium-beta

RUN apt-get update

RUN apt-get install -y chromium-browser

RUN apt-get install -y libva-glx1 libva-x11-1 i965-va-driver
RUN adduser chrome video
# TODO missmatch of group ids (fedora video = ubuntu irc, gid of device is important)
VOLUME ["/home/chrome"]

EXPOSE 5900

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
