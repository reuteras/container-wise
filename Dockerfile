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
    git clone -b 'v3.0.0' --single-branch https://github.com/arkime/arkime.git

WORKDIR /arkime/wiseService/
RUN npm install
WORKDIR /arkime
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
COPY --from=build-env /arkime/wiseService/ /data/moloch/wiseService/
COPY --from=build-env /arkime/node_modules/ /data/moloch/node_modules/
COPY files/ /data/moloch/wiseService/
RUN chmod 777 /data/moloch/wiseService/start_script.sh

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 8081

CMD ["/data/moloch/wiseService/start_script.sh"]
