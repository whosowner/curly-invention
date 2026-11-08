
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=desktop
ENV HOME=/home/desktop

RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    dbus-x11 \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash desktop

RUN mkdir -p /home/desktop/.vnc \
    && chown -R desktop:desktop /home/desktop

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 10000

CMD ["/start.sh"]
