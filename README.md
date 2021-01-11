# Docker Nginx WebDAV

![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/bcgdesign/nginx-webdav/latest?label=latest) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bencgreen/docker-nginx-webdav/build?label=github) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/bcgdesign/nginx-webdav?label=docker) ![Docker Pulls](https://img.shields.io/docker/pulls/bcgdesign/nginx-webdav?label=pulls) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/bcgdesign/nginx-webdav/latest?label=size)

[Docker Repository](https://hub.docker.com/r/bcgdesign/nginx-webdav) - [bcg|design ecosystem](https://github.com/bencgreen/docker)

Very Simple WebDAV server - serves files mounted in `/www`.  There is **no** authentication, so this should be used behind a reverse proxy, and local only, unless you know what you are doing.

By default files are served read-only - change two environment variables to enable full write access as well.

## Ports

* 80 (from base image)

## Environment Variables

```bash
DAV_ACCESS="r"     # set to "rw" to enable read-write access
DAV_METHODS="off"  # set to "PUT DELETE MKCOL COPY MOVE" (or any variation) to enable full write access
```

## Authors

* [Ben Green](https://github.com/bencgreen)

## License

> MIT

## Copyright

> Copyright (c) 2020 Ben Green <https://bcgdesign.com>  
> Unless otherwise stated
