FROM circleci/node:8.11.2-stretch
MAINTAINER "Manojvv" "manojv@ilimi.in"
USER root
COPY src /opt/content/
WORKDIR /opt/content/
RUN npm install --unsafe-perm

FROM node:8.11-slim
MAINTAINER "Manojvv" "manojv@ilimi.in"

RUN sed -i '/jessie-updates/d' /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian jessie-backports main" >> /etc/apt/sources.list \
    && echo "deb http://archive.debian.org/debian jessie main" >> /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt update \
    && apt-get clean \
    && useradd -m sunbird
USER sunbird
COPY --from=0 --chown=sunbird /opt/content /home/sunbird/mw/content
WORKDIR /home/sunbird/mw/content/
CMD ["node", "app.js", "&"]
