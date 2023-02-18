FROM bfren/nginx:nginx1.22-4.0.29

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-nginx-webdav"

ARG BF_IMAGE
ARG BF_VERSION

ENV \
    # set to "r" or "rw" (without quotes) to enable read-only / read-write access
    WEBDAV_ACCESS=r \
    # set to "PUT DELETE MKCOL COPY MOVE" (or any variation, without quotes) to enable full write access
    WEBDAV_METHODS=off

COPY ./overlay /

RUN bf-install
