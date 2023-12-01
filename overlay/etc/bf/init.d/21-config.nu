use bf
bf env load

# Generate nginx configuration file
def main [] {
    bf write "Generating localhost configuration file."
    bf esh template $"(bf env NGINX_ETC_SITES)/localhost.conf"
}
