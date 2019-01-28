# builder image #
FROM node:8-alpine AS build-env
USER root
WORKDIR /
RUN apk update && \
    apk add --no-cache \
      git \
      python \
      make \
      g++

RUN git clone https://github.com/aol/moloch.git
WORKDIR /moloch/wiseService/
RUN npm install
WORKDIR /moloch
RUN npm ci

# Base Image #
FROM node:8-alpine

#####################
# Setup
#####################
USER root

RUN apk update && \
    apk add --no-cache \
      ca-certificates

WORKDIR /data/moloch/wiseService/

RUN mkdir /data/moloch/node_modules
COPY --from=build-env /moloch/wiseService/ /data/moloch/wiseService/
COPY --from=build-env /moloch/node_modules/ /data/moloch/node_modules/
COPY files/ /data/moloch/wiseService/
RUN chmod 777 /data/moloch/wiseService/start_script.sh

#####################
# Ports
#####################

## Set container to listen on port 8081 for WISE queries ##
EXPOSE 8081

CMD "/data/moloch/wiseService/start_script.sh"
