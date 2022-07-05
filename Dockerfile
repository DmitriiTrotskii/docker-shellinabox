ARG VER=2.20

FROM ubuntu:22.04 as builder

ARG VER

RUN apt update && \
    apt install -y dpkg-dev debhelper && \
    apt install -y git libssl-dev libpam0g-dev zlib1g-dev dh-autoreconf && \
    git clone https://github.com/shellinabox/shellinabox.git && cd shellinabox && \
    git checkout v${VER} && \
    dpkg-buildpackage -b

FROM ubuntu:22.04

ARG VER

COPY --from=builder /shellinabox_${VER}_amd64.deb /tmp/

COPY ./entrypoint.sh /usr/local/sbin/
RUN chmod +x /usr/local/sbin/entrypoint.sh

RUN apt update && apt install -y openssl ssh-client wget && \
    dpkg -i /tmp/shellinabox_${VER}_amd64.deb && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN ln -sf '/etc/shellinabox/options-enabled/00+Black on White.css' \
      /etc/shellinabox/options-enabled/00+Black-on-White.css && \
    ln -sf '/etc/shellinabox/options-enabled/00_White On Black.css' \
      /etc/shellinabox/options-enabled/00_White-On-Black.css && \
    ln -sf '/etc/shellinabox/options-enabled/01+Color Terminal.css' \
      /etc/shellinabox/options-enabled/01+Color-Terminal.css

EXPOSE 4200

ENTRYPOINT [ "/usr/local/sbin/entrypoint.sh" ]
