# Nginx + WebDAV

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-nginx-webdav) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Fnginx-webdav) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Fnginx-webdav) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-nginx-webdav/build.yml?branch=main)

[Docker Hub](https://hub.docker.com/r/bfren/nginx-webdav) - [Quay.io](https://quay.io/repository/bfren/nginx-webdav) - [bfren ecosystem](https://github.com/bfren/docker)

## Introduction

A very simple [WebDAV](https://en.wikipedia.org/wiki/WebDAV) file server: the files in `/www`, shared over HTTP so they can be browsed, downloaded and (if you allow it) uploaded and changed.

It is [Nginx](https://github.com/bfren/docker-nginx) with:

* nginx's WebDAV module, plus the `dav-ext` module for the `PROPFIND` and `OPTIONS` methods WebDAV clients use to list folders
* a browsable index page for each folder
* read-only access by default - turn on writing with one environment variable
* no upload size limit

There is **no authentication**. Run it on a private network, or behind a reverse proxy that adds a login - [Caddy Proxy](https://github.com/bfren/docker-caddy-proxy) can do this.

## Quickstart

Share the files in `./files` (read-only) on port 8080:

```sh
docker run -d --name dav -p 8080:80 -v ./files:/www quay.io/bfren/nginx-webdav
```

Or with Docker Compose, allowing changes:

```yaml
services:
  dav:
    image: quay.io/bfren/nginx-webdav:8.0
    environment:
      - BF_NGINX_WEBDAV_METHODS=PUT DELETE MKCOL COPY MOVE
    ports:
      - "8080:80"
    volumes:
      - ./files:/www
```

Open `http://localhost:8080` in a browser, or connect a WebDAV client to the same address.

## Features

* 📂 Browse folders in a web browser, or connect with a WebDAV client
* 🔒 Read-only unless you enable the write methods
* ⬆️ No upload size limit, and folders are created as needed when uploading
* 🧩 Add your own nginx configuration to the server block, in `/etc/nginx/custom`
* 🗜️ Everything from [Nginx](https://github.com/bfren/docker-nginx#features): compression, logs, daily reload and a health check

## Tags

Images are published to Docker Hub (`bfren/nginx-webdav`) and Quay.io (`quay.io/bfren/nginx-webdav`) for `linux/amd64`, `linux/arm/v7` and `linux/arm64`. There is one build, on nginx 1.30 and Alpine 3.24.

| Tag       | Example | Use when                                   |
| --------- | ------- | ------------------------------------------ |
| `latest`  |         | You always want the newest image           |
| `MAJOR`   | `8`     | You want updates, but not breaking changes |
| `MINOR`   | `8.0`   | You want fixes only - **recommended**      |
| `VERSION` | `8.0.0` | You want to pin this image exactly         |

## Configuration

### Ports

| Port | Purpose                                                        |
| ---- | -------------------------------------------------------------- |
| `80` | HTTP - put a reverse proxy in front of it for SSL and a login. |

### Volumes

| Volume | Purpose                                                                                                                           |
| ------ | --------------------------------------------------------------------------------------------------------------------------------- |
| `/www` | The files to share. Unlike [Nginx](https://github.com/bfren/docker-nginx), this is served directly - there is no `public` folder. |

### Environment Variables

| Variable                  | Values                                        | Description                                                                                                                                                                                          | Default |
| ------------------------- | --------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `BF_NGINX_WEBDAV_METHODS` | `off`, or any of `PUT DELETE MKCOL COPY MOVE` | The methods that change files. `off` makes the server read-only; `PUT DELETE MKCOL COPY MOVE` allows everything.                                                                                     | `off`   |
| `BF_NGINX_WEBDAV_ACCESS`  | `r`, `rw`                                     | Permissions given to *everyone else* on files and folders the server creates: `r` (readable) or `rw` (also writable). It does not control what clients can do - `BF_NGINX_WEBDAV_METHODS` does that. | `r`     |

[Nginx](https://github.com/bfren/docker-nginx#environment-variables) adds the nginx variables (access log, health check URI, …), and [Alpine + S6](https://github.com/bfren/docker-alpine-s6#environment-variables) adds timezone and cron.

## How It Works

### Starting

When the container starts, [Nginx](https://github.com/bfren/docker-nginx#starting) sets up nginx, then this image replaces the default site with a WebDAV server generated from a template (`/etc/nginx/sites/localhost.conf`), using the environment variables above. The nginx image's usual set-up of `/www/public` (creating it, adding a welcome page, setting ownership) is turned off - your files are left exactly as they are.

### Permissions

nginx runs as the `www` user (UID 1000), so:

* to read files, they must be readable by that user or by everyone
* to change files, `/www` (and anything in it you want to change) must be writable by UID 1000 - e.g. `chown -R 1000:1000 ./files` on the host

New files and folders are owned by `www`, with permissions set by `BF_NGINX_WEBDAV_ACCESS`.

### Custom configuration

Every `.conf` file in `/etc/nginx/custom` is included inside the server block, so it can contain anything valid there - including `location` blocks. For example, to allow longer uploads:

```nginx
# /etc/nginx/custom/timeouts.conf
client_body_timeout             300s;
```

Earlier versions included `/etc/nginx/sites/custom.conf` instead. If you mounted a file there, move it to `/etc/nginx/custom/` - anything left in `/etc/nginx/sites` is now only included at the `http` level.

### Health check, logs and reloading

These come from [Nginx](https://github.com/bfren/docker-nginx#health-check). The health check loads `http://localhost`, which is the index page for `/www`.

## Building on this image

```dockerfile
FROM quay.io/bfren/nginx-webdav:8.0

COPY ./overlay /
RUN bf-install
```

See [Nginx](https://github.com/bfren/docker-nginx#building-on-this-image) for the rest.

## Testing

```sh
./test.nu        # builds the image and runs /test
```

`/test` runs this image's tests alongside the base images' tests, and fails if tests don't execute. They check that the `dav-ext` module is installed, and generate the site from its template - read-only and with the write methods enabled - checking the settings and that `nginx -t` accepts it, including with a `location` block in `/etc/nginx/custom`.

## Troubleshooting

### Uploads fail with 405 Not Allowed

The server is read-only - set `BF_NGINX_WEBDAV_METHODS` to the methods you want to allow.

### Uploads fail with 403 Forbidden or 500

The `www` user (UID 1000) can't write to `/www` - change the ownership or permissions of the folder on the host.

### The container stops at start-up

nginx's configuration test failed - often because of a file in `/etc/nginx/custom`, or a server-level file left in `/etc/nginx/sites` (see [Custom configuration](#custom-configuration)). Check `docker logs`.

### My file manager connects, but read-only

Some clients (e.g. macOS Finder and Windows Explorer) need WebDAV locking (`LOCK` and `UNLOCK`) before they will write, and this image doesn't enable it. Use a client that doesn't need locks, such as [Cyberduck](https://cyberduck.io) or [rclone](https://rclone.org), or a command-line tool such as `curl`.

## FAQs

### How do I add a password?

Put a reverse proxy in front of it that handles logins, such as [Caddy Proxy](https://github.com/bfren/docker-caddy-proxy). Never expose this image directly to the internet.

## Licence

> [MIT](https://mit.bfren.dev/2020)

## Copyright

> Copyright (c) 2020-2026 [bfren](https://bfren.dev) (unless otherwise stated)
