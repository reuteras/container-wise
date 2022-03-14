# Build container
FROM node:16-alpine AS build-env
LABEL maintainer="Coding <code@ongoing.today>"

USER root
WORKDIR /

RUN apk update && \
    apk add --no-cache \
        automake \
        autoconf \
        g++ \
        git \
        make \
        musl-libintl \
        py3-pip \
        python3 \
        re2c && \
    git clone -b 'v3.4.0' --single-branch https://github.com/arkime/arkime.git

WORKDIR /arkime/wiseService
RUN npm install
WORKDIR /arkime
RUN npm install
RUN npm run wise:build
USER appuser

# Container
FROM node:16-alpine
USER root
RUN apk update && \
    apk add --no-cache \
      ca-certificates

WORKDIR /opt/arkime/wiseService/
COPY --from=build-env /arkime/common/ /opt/arkime/common/
COPY --from=build-env /arkime/wiseService/ /opt/arkime/wiseService/
COPY --from=build-env /arkime/node_modules/ /opt/arkime/node_modules/
COPY --from=build-env /arkime/assets/Arkime_Icon* /opt/arkime/assets/
COPY version.js /opt/arkime/viewer/version.js
COPY files/ /opt/arkime/wiseService/
RUN sed -i -e "s/VERSION/3.3.0/" /opt/arkime/viewer/version.js && \
    chmod 755 /opt/arkime/wiseService/start_script.sh

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 8081

CMD ["/opt/arkime/wiseService/start_script.sh"]
