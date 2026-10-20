use std/assert


#======================================================================================================================
# helpers
#======================================================================================================================

# Copy /etc/nginx to a temporary directory, generate the WebDAV site from its template there, and return the paths -
# tests run in parallel, so this must never touch the real configuration
def render [
    methods: string = "off" # BF_NGINX_WEBDAV_METHODS
    access: string = "r"    # BF_NGINX_WEBDAV_ACCESS
]: nothing -> record<dir: string, conf: string, site: string> {
    let dir = mktemp --directory
    ^cp -a /etc/nginx/. $dir

    let site = $"($dir)/sites/localhost.conf"
    let vars = {
        BF_NGINX_WWW: "/www"
        BF_NGINX_WEBDAV_METHODS: $methods
        BF_NGINX_WEBDAV_ACCESS: $access
        BF_NGINX_WEBDAV_EXT_METHODS: "PROPFIND OPTIONS"
    }
    with-env $vars { ^esh -o $site /etc/bf/templates/localhost.conf.esh }

    {dir: $dir, conf: $"($dir)/nginx.conf", site: $site}
}

# Run 'nginx -t' against a rendered configuration, remove it, and return the result
def check [r: record]: nothing -> record {
    let result = ^nginx -t -c $r.conf | complete
    rm --recursive --force $r.dir
    $result
}


#======================================================================================================================
# installation
#======================================================================================================================

export def install__dav_ext_module_is_installed [] {
    let result = ^apk info -e nginx-mod-http-dav-ext | complete

    assert equal 0 $result.exit_code "nginx-mod-http-dav-ext should be installed"
}


#======================================================================================================================
# site
#======================================================================================================================

export def site__default__is_read_only_and_valid [] {
    let r = render
    let site = open --raw $r.site
    let result = check $r

    assert ($site =~ 'dav_methods\s+off;') "write methods should be off by default"
    assert ($site =~ 'dav_access\s+all:r;') "new files should be readable by all by default"
    assert ($site =~ 'dav_ext_methods\s+PROPFIND OPTIONS;') "PROPFIND and OPTIONS should always be enabled"
    assert equal 0 $result.exit_code $"nginx -t failed: ($result.stderr)"
}

export def site__write_methods__are_enabled_and_valid [] {
    let r = render "PUT DELETE MKCOL COPY MOVE" "rw"
    let site = open --raw $r.site
    let result = check $r

    assert ($site =~ 'dav_methods\s+PUT DELETE MKCOL COPY MOVE;') "write methods should be enabled"
    assert ($site =~ 'dav_access\s+all:rw;') "new files should be writable by all"
    assert equal 0 $result.exit_code $"nginx -t failed: ($result.stderr)"
}

export def site__custom_conf__is_included_in_server_block [] {
    # a location block is only valid inside a server block - this fails if custom files are included at http level
    let r = render
    mkdir $"($r.dir)/custom"
    "location = /bf-test {\n    return 204;\n}\n" | save $"($r.dir)/custom/test.conf"
    let site = open --raw $r.site
    let result = check $r

    assert ($site =~ 'include\s+custom/\*\.conf;') "the site should include custom/*.conf"
    assert equal 0 $result.exit_code $"nginx -t failed with a location block in custom/: ($result.stderr)"
}
