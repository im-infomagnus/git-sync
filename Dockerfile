FROM alpine:3.18

LABEL "repository"="https://github.com/valtech-sd/git-sync"
LABEL "homepage"="https://github.com/valtech-sd/git-sync"
LABEL "maintainer"="us.san_diego_engineering@valtech.com"

RUN apk add --no-cache git git-lfs openssh-client && \
  echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

ADD *.sh /

ENTRYPOINT ["/entrypoint.sh"]
