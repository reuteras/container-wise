# Build container
FROM node:22-trixie@sha256:c103d7b5aa3bf627c8b98db941d52556f04e0b5d9352b3d7b6391245d26620f8 AS build-env
LABEL maintainer="Coding <code@ongoing.today>"

USER root
WORKDIR /

# hadolint ignore=DL3008,DL3018
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        automake \
        autoconf \
        g++ \
        git \
        make \
        python3-pip \
        python3 \
        re2c && \
    rm -rf /var/lib/apt/lists/* && \
    git clone -b 'v6.9.2' --single-branch https://github.com/arkime/arkime.git

WORKDIR /arkime/wiseService
RUN npm install
WORKDIR /arkime
RUN npm install && \
     npm run wise:bundle
USER appuser

# Container
FROM node:22-trixie@sha256:c103d7b5aa3bf627c8b98db941d52556f04e0b5d9352b3d7b6391245d26620f8
USER root
# hadolint ignore=DL3008,DL3018
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/arkime/wiseService/
COPY --from=build-env /arkime/common/ /opt/arkime/common/
COPY --from=build-env /arkime/wiseService/ /opt/arkime/wiseService/
COPY --from=build-env /arkime/node_modules/ /opt/arkime/node_modules/
COPY --from=build-env /arkime/assets/Arkime_Icon* /opt/arkime/assets/
COPY version.js /opt/arkime/common/version
COPY files/ /opt/arkime/wiseService/
RUN sed -i -e "s/VERSION/6.9.2/" /opt/arkime/common/version && \
    chmod 755 /opt/arkime/wiseService/start_script.sh

RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup
USER appuser

EXPOSE 8081

CMD ["/opt/arkime/wiseService/start_script.sh"]
