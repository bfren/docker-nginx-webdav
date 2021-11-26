FROM bfren/nginx:nginx1.20-2.3.0

ENV \
    # set to "r" or "rw" to enable read-only / read-write access
    WEBDAV_ACCESS="r" \
    # set to "PUT DELETE MKCOL COPY MOVE" (or any variation) to enable full write access
    WEBDAV_METHODS="off"

COPY ./overlay /
COPY ./NGINX_BUILD /tmp/VERSION

RUN bf-install
