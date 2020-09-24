FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y curl xz-utils git sudo supervisor && \
    apt-get clean

RUN useradd -ms /bin/bash omnia
RUN mkdir -m 0755 /nix && chown omnia /nix
USER omnia
WORKDIR /home/omnia

RUN curl -L https://nixos.org/nix/install | sh
RUN . /home/omnia/.nix-profile/etc/profile.d/nix.sh

ENV NIX_LINK=$HOME/.nix-profile
ENV PATH="/home/omnia/.nix-profile/bin:${PATH}"
ENV NIX_PROFILES="/nix/var/nix/profiles/default /home/omnia/.nix-profile"
RUN nix-env -i --verbose -f https://github.com/makerdao/oracles-v2/tarball/stable

USER root
#RUN usermod -a -G tty omnia
COPY supervisord.conf .
COPY start-ssb.sh .
COPY start-omnia.sh .
COPY setup.sh .
RUN chmod a+x *.sh

CMD ["/usr/bin/supervisord","-c","/home/omnia/supervisord.conf"]
