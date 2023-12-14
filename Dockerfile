# Build container
FROM node:18-bookworm AS build-env
LABEL maintainer="Coding <code@ongoing.today>"

USER root
WORKDIR /

# hadolint ignore=DL3018
RUN apt-get update && \
    apt-get install -y \
        automake \
        autoconf \
        g++ \
        git \
        make \
        python3-pip \
        python3 \
        re2c && \
    git clone -b 'v4.6.0' --single-branch https://github.com/arkime/arkime.git

WORKDIR /arkime/wiseService
RUN npm install
WORKDIR /arkime
RUN npm install && \
     npm run wise:build
USER appuser

# Container
FROM node:18-bookworm
USER root
# hadolint ignore=DL3018
RUN apt-get update && \
    apt-get install -y \
      ca-certificates

WORKDIR /opt/arkime/wiseService/
COPY --from=build-env /arkime/common/ /opt/arkime/common/
COPY --from=build-env /arkime/wiseService/ /opt/arkime/wiseService/
COPY --from=build-env /arkime/node_modules/ /opt/arkime/node_modules/
COPY --from=build-env /arkime/assets/Arkime_Icon* /opt/arkime/assets/
COPY version.js /opt/arkime/common/version
COPY files/ /opt/arkime/wiseService/
RUN sed -i -e "s/VERSION/4.6.0/" /opt/arkime/common/version && \
    chmod 755 /opt/arkime/wiseService/start_script.sh

RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup
USER appuser

EXPOSE 8081

CMD ["/opt/arkime/wiseService/start_script.sh"]
