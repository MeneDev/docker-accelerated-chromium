FROM ubuntu:16.04

LABEL maintainer="Tomohisa Kusano <siomiz@gmail.com>"

COPY copyables /

ADD https://dl.google.com/linux/linux_signing_key.pub /tmp/

RUN apt-key add /tmp/linux_signing_key.pub \
	&& apt-get update \
	&& apt-get install -y \
	google-chrome-stable \
	chrome-remote-desktop \
	fonts-takao \
	pulseaudio \
	supervisor \
	x11vnc \
	fluxbox \
	v4l-utils \
	&& apt-get clean \
	&& rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/* /tmp/* \
	&& useradd -m -G chrome-remote-desktop,pulse-access chrome \
	&& usermod -s /bin/bash chrome \
	&& ln -s /crdonly /usr/local/sbin/crdonly \
	&& ln -s /update /usr/local/sbin/update \
	&& mkdir -p /home/chrome/.config/chrome-remote-desktop \
	&& mkdir -p /home/chrome/.fluxbox \
	&& echo ' \n\
		session.screen0.toolbar.visible:        false\n\
		session.screen0.fullMaximization:       true\n\
		session.screen0.maxDisableResize:       true\n\
		session.screen0.maxDisableMove: true\n\
		session.screen0.defaultDeco:    NONE\n\
	' >> /home/chrome/.fluxbox/init \
	&& chown -R chrome:chrome /home/chrome/.config /home/chrome/.fluxbox

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
RUN adduser chrome irc
VOLUME ["/home/chrome"]

EXPOSE 5900

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
