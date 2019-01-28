# Wise-alpine-Docker
A node8:alpine based docker image for Moloch's WISE application.
## Mounts
This image does not require mounts, but it is preferred that you overwrite the wiseService.ini file with your own. an easy way of doing that is to create your own custom Configuration and mount it over the existing. E.g:
`-v /Location/of/file_to/mount/wiseService.ini:/data/moloch/wiseService/wiseService.ini`
