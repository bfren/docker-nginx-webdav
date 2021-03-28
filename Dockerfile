FROM bcgdesign/nginx:alpine3.13-2.0.8

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
    org.label-schema.name="Nginx WebDAV" \
    org.label-schema.version="latest" \
    org.label-schema.vendor="Ben Green" \
    org.label-schema.schema-version="1.0"

ENV \
    # set to "r" or "rw" to enable read-only / read-write access
    WEBDAV_ACCESS="r" \
    # set to "PUT DELETE MKCOL COPY MOVE" (or any variation) to enable full write access
    WEBDAV_METHODS="off"

COPY ./overlay /
COPY ./NGINX_BUILD /tmp/VERSION

RUN bcg-install
