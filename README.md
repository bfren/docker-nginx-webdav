# Docker Nginx WebDAV

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bencgreen/docker-nginx-webdav) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bencgreen/docker-nginx-webdav/build?label=github) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/bcgdesign/nginx-webdav?label=docker) ![Docker Pulls](https://img.shields.io/docker/pulls/bcgdesign/nginx-webdav?label=pulls) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/bcgdesign/nginx-webdav/latest?label=size)

[Docker Repository](https://hub.docker.com/r/bcgdesign/nginx-webdav) - [bcg|design ecosystem](https://github.com/bencgreen/docker)

Very Simple WebDAV server - serves files mounted in `/www`.  There is **no** authentication, so this should be used behind a reverse proxy, and local only, unless you know what you are doing.

By default files are served read-only - change two environment variables to enable full write access as well.

## Contents

* [Ports](#ports)
* [Environment Variables](#environment-variables)
* [Authors / Licence / Copyright](#authors)

## Ports

* 80 (from base image)

## Environment Variables

| Variable         | Values      | Description                                                | Default |
| ---------------- | ----------- | ---------------------------------------------------------- | ------- |
| `WEBDAV_ACCESS`  | 'r' or 'rw' | Set to 'r' for read-only or 'rw' for read/write access.    | r       |
| `WEBDAV_METHODS` | string      | For full write access set to 'PUT DELETE MKCOL COPY MOVE'. | off     |

## Authors

* [Ben Green](https://github.com/bencgreen)

## License

> MIT

## Copyright

> Copyright (c) 2021 Ben Green <https://bcgdesign.com>
> Unless otherwise stated
