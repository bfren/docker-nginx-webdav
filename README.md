# Docker Nginx WebDAV

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-nginx-webdav) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Fnginx-webdav) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Fnginx-webdav) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-nginx-webdav/dev.yml?branch=main)

[Docker Repository](https://hub.docker.com/r/bfren/nginx-webdav) - [bfren ecosystem](https://github.com/bfren/docker)

Very Simple WebDAV server - serves files mounted in `/www`.  There is **no** authentication, so this should be used behind a reverse proxy, and local only, unless you know what you are doing.

By default files are served read-only - change two environment variables to enable full write access as well.

## Contents

* [Ports](#ports)
* [Environment Variables](#environment-variables)
* [Licence / Copyright](#licence)

## Ports

* 80 (from base image)

## Environment Variables

| Variable         | Values      | Description                                                              | Default |
| ---------------- | ----------- | ------------------------------------------------------------------------ | ------- |
| `NGINX_WEBDAV_ACCESS`  | 'r' or 'rw' | Set to 'r' for read-only or 'rw' for read/write access (without quotes). | r       |
| `NGINX_WEBDAV_METHODS` | string      | For full write access set to 'PUT DELETE MKCOL COPY MOVE'.               | off     |

## Licence

> [MIT](https://mit.bfren.dev/2020)

## Copyright

> Copyright (c) 2020-2023 [bfren](https://bfren.dev) (unless otherwise stated)
