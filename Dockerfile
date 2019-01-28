#####################
# Builder container
#####################
# builder image #
FROM node:8-alpine AS build-env
USER root
WORKDIR /
# install dependancies #
RUN apk update && \
    apk add --no-cache \
      git \
      python \
      make \
      g++

# Clone taged repo #
RUN git clone -b 'v1.7.0' --single-branch --depth 1 https://github.com/aol/moloch.git
# Move into repo and install #
WORKDIR /moloch/wiseService/
RUN npm install
WORKDIR /moloch
RUN npm ci
# Done with pre-build #

#####################
# Primary image Build
#####################
# Base Image #
FROM node:8-alpine
#####################
# Setup
#####################
USER root
# Add ca-certificates for publicly signed cert support #
RUN apk update && \
    apk add --no-cache \
      ca-certificates

WORKDIR /data/moloch/wiseService/
# Copy over Wise files from builder container #
RUN mkdir /data/moloch/node_modules
COPY --from=build-env /moloch/wiseService/ /data/moloch/wiseService/
COPY --from=build-env /moloch/node_modules/ /data/moloch/node_modules/
# Copy over configs and start script #
COPY files/ /data/moloch/wiseService/
# Perms for start script #
RUN chmod 777 /data/moloch/wiseService/start_script.sh

#####################
# Ports
#####################
## Set container to listen on port 8081 for WISE queries ##
EXPOSE 8081

CMD "/data/moloch/wiseService/start_script.sh"
