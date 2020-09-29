# Build container
FROM node:10-alpine AS build-env
LABEL maintainer="Coding <code@ongoing.today>"

USER root
WORKDIR /

RUN apk update && \
    apk add --no-cache \
        git \
        python \
        make \
        g++ && \
    git clone -b 'v2.4.1' --single-branch https://github.com/aol/moloch.git

WORKDIR /moloch/wiseService/
RUN npm install
WORKDIR /moloch
RUN npm ci
USER appuser

# Container
FROM node:10-alpine
USER root
RUN apk update && \
    apk add --no-cache \
      ca-certificates

WORKDIR /data/moloch/wiseService/
RUN mkdir -p /data/moloch/node_modules
COPY --from=build-env /moloch/wiseService/ /data/moloch/wiseService/
COPY --from=build-env /moloch/node_modules/ /data/moloch/node_modules/
COPY files/ /data/moloch/wiseService/
RUN chmod 777 /data/moloch/wiseService/start_script.sh

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 8081

CMD ["/data/moloch/wiseService/start_script.sh"]
