# container-wise

A node10:alpine based docker image for Moloch's WISE application forked from [problematiq/Wise-alpine-Docker](https://github.com/problematiq/Wise-alpine-Docker).

## Mounts

This image does not require mounts, but it is preferred that you overwrite the wiseService.ini file with your own. An easy way of doing that is to create your own custom configuration and mount it over the existing.

    docker run -d -v /Location/of/file_to/mount/wiseService.ini:/data/moloch/wiseService/wiseService.ini --name wise -p 8081:8081 reuteras/container-wise
