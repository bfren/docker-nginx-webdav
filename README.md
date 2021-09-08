# Docker Nginx WebDAV

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-nginx-webdav) ![Docker Pulls](https://img.shields.io/docker/pulls/bfren/nginx-webdav?label=pulls) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/bfren/nginx-webdav/latest?label=size)<br/>
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bfren/docker-nginx-webdav/dev?label=build)

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

| Variable         | Values      | Description                                                | Default |
| ---------------- | ----------- | ---------------------------------------------------------- | ------- |
| `WEBDAV_ACCESS`  | 'r' or 'rw' | Set to 'r' for read-only or 'rw' for read/write access.    | r       |
| `WEBDAV_METHODS` | string      | For full write access set to 'PUT DELETE MKCOL COPY MOVE'. | off     |

## Licence

> [MIT](https://mit.bfren.dev/2020)

## Copyright

> Copyright (c) 2021 bfren
> Unless otherwise stated
