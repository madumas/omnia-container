FROM ubuntu:18.04

LABEL stage=ubuntu
RUN apt-get update && \
    apt-get install -y curl xz-utils git && \
    apt-get clean
RUN useradd -ms /bin/bash omnia
RUN mkdir -m 0755 /nix && chown omnia /nix
USER omnia
WORKDIR /home/omnia

LABEL stage=nix
RUN curl -L https://nixos.org/nix/install | sh
RUN . /home/omnia/.nix-profile/etc/profile.d/nix.sh

LABEL stage=omnia
ENV NIX_LINK=$HOME/.nix-profile
ENV PATH="/home/omnia/.nix-profile/bin:${PATH}"
ENV NIX_PROFILES="/nix/var/nix/profiles/default /home/omnia/.nix-profile"
RUN nix-env -i --verbose -f https://github.com/makerdao/oracles-v2/tarball/stable

RUN mkdir /home/omnia/logs

USER root
RUN apt-get install -y sudo supervisor datamash jshon jq
#RUN curl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py > /usr/local/bin/systemctl
#RUN chmod a+x /usr/local/bin/systemctl
RUN usermod -a -G tty omnia
COPY supervisord.conf .
#/etc/supervisor/conf.d/supervisord.conf
COPY start-ssb.sh .
COPY start-omnia.sh .
COPY setup.sh .
RUN chmod a+x *.sh

#CMD ["/bin/bash","/home/omnia/start.sh"]
CMD ["/usr/bin/supervisord","-c","/home/omnia/supervisord.conf"]
