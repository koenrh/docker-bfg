FROM amazoncorretto:19.0.0@sha256:40e562a6f53a83e46b20e4d52344daa3ad828001dc795a66ba5f3f771846472e
LABEL maintainer "Koen Rouwhorst <info@koenrouwhorst.nl>"

# NOTE: https://rtyley.github.io/bfg-repo-cleaner/
ENV BFG_VERSION="1.14.0"
ENV BFG_CHECKSUM="1a75e9390541f4b55d9c01256b361b815c1e0a263e2fb3d072b55c2911ead0b7"

RUN yum upgrade -y && \
  yum install -y shadow-utils

ENV HOME /home/bfg
RUN useradd --create-home --home-dir $HOME bfg \
  && chown -R bfg:bfg $HOME

COPY ./entrypoint.sh /home/bfg/
RUN chmod +x /home/bfg/entrypoint.sh

WORKDIR /tmp

RUN curl "https://repo1.maven.org/maven2/com/madgag/bfg/$BFG_VERSION/bfg-$BFG_VERSION.jar" \
  -o "bfg-$BFG_VERSION.jar" \
  && echo "$BFG_CHECKSUM  bfg-$BFG_VERSION.jar" | sha256sum -c - \
  && mv "bfg-$BFG_VERSION.jar" /home/bfg/bfg.jar

WORKDIR "$HOME/workspace"
USER bfg

ENTRYPOINT ["/home/bfg/entrypoint.sh", "/home/bfg/bfg.jar"]
