ARG NGINX_VERSION=1.18.0-r1
FROM bcgdesign/nginx:${NGINX_VERSION}

LABEL maintainer="Ben Green <ben@bcgdesign.com>" \
    org.label-schema.name="Nginx WebDAV" \
    org.label-schema.version="latest" \
    org.label-schema.vendor="Ben Green" \
    org.label-schema.schema-version="1.0"


COPY ./VERSION /tmp/VERSION
RUN apk -U upgrade \
    && apk add \
        nginx-mod-http-dav-ext=${NGINX_VERSION} \
    && rm -rf /var/cache/apk/* /www/* /tmp/*
