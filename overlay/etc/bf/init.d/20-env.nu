use bf
bf env load

# Set environment variables
def main [] {
    bf env set NGINX_WEBDAV_EXT_METHODS "PROPFIND OPTIONS"

    # return nothing
    return
}
