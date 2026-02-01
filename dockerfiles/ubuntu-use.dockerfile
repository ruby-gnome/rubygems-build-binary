ARG VERSION
FROM ubuntu:${VERSION}

RUN \
  echo "debconf debconf/frontend select Noninteractive" | \
    debconf-set-selections

RUN \
  apt-get update && \
  apt-get install -y \
    ruby-dev \
    sudo

RUN \
  useradd --user-group --create-home devel

RUN \
  echo "devel ALL=(ALL:ALL) NOPASSWD:ALL" | \
    EDITOR=tee visudo -f /etc/sudoers.d/devel

USER devel
WORKDIR /home/devel
