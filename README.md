# container-wise

![Linter](https://github.com/reuteras/container-wise/workflows/Linter/badge.svg)

A node:16-alpine based docker image for [Arkime](https://arkime.com/)'s [WISE](https://arkime.com/wise).

The base of this repo forked from [problematiq/Wise-alpine-Docker](https://github.com/problematiq/Wise-alpine-Docker).

## Mounts

This image doesn't require mounts, but it is preferred that you overwrite the wiseService.ini file with your own. An easy way of doing that is to create your own custom configuration and mount it over the one included in the image.

    docker run -d -v /Location/of/file_to/mount/wiseService.ini:/opt/arkime/wiseService/wiseService.ini --name wise -p 8081:8081 reuteras/container-wise

Alternative you can run the it with default settings.

    docker run -d --name wise -p 8081:8081 reuteras/container-wise
