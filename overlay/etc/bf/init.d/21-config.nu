use bf
bf env load

# Generate nginx configuration file
def main [] {
    bf write "Generating nginx configuration file."
    bf esh template "localhost.conf" (bf env NGINX_ETC_SITES)
}
