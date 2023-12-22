FROM bfren/nginx:nginx1.24-alpine3.19-6.1.1

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-nginx-webdav"

ARG BF_IMAGE
ARG BF_VERSION

COPY ./overlay /

ENV \
    # set to "r" or "rw" (without quotes) to enable read-only / read-write access
    BF_NGINX_WEBDAV_ACCESS=r \
    # set to "PUT DELETE MKCOL COPY MOVE" (or any variation, without quotes) to enable full write access
    BF_NGINX_WEBDAV_METHODS=off

RUN bf-install
