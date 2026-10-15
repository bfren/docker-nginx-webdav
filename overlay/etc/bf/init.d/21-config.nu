use bf
use bf-s6
bf env load

# Generate nginx configuration file
def main [] {
    bf write "Generating localhost configuration file."
    bf-s6 esh template $"(bf env NGINX_ETC_SITES)/localhost.conf"
}
