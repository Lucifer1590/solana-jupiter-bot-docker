FROM node:16.19.0-alpine3.17
RUN apk add --no-cache tini ttyd socat unzip openssl openssh ca-certificates git tmux python3 nano && \
# Configure a nice terminal
    echo "export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /etc/profile && \
# Fake poweroff (stops the container from the inside by sending SIGTERM to PID 1)
    echo "alias poweroff='kill 1'" >> /etc/profile

WORKDIR /home
RUN git clone https://github.com/arbprotocol/solana-jupiter-bot
WORKDIR /home/solana-jupiter-bot
RUN yarn
WORKDIR /home/solana-jupiter-bot
ENV TINI_KILL_PROCESS_GROUP=1
EXPOSE 7681
ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "ttyd", "-s", "3", "-t", "titleFixed=/bin/sh", "-t", "rendererType=webgl", "-t", "disableLeaveAlert=true", "/bin/sh", "-i", "-l" ]
