cat <<EOF | sed -e 's/ *\#.*$//g'
DATABASE_PASSWORD="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
FULLTEXTSEARCH_PASSWORD="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
IMAGINARY_SECRET="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
ONLYOFFICE_SECRET="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
RECORDING_SECRET="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
REDIS_PASSWORD="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
SIGNALING_SECRET="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
TALK_INTERNAL_SECRET="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
TIMEZONE=Europe/Berlin          # TODO! This is the timezone that your containers will use.
TURN_SECRET="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!
WHITEBOARD_SECRET="$(base64 </dev/urandom | tr -d '/' | head -c 20)"          # TODO! This needs to be a unique and good password!

CLAMAV_ENABLED="no"          # Setting this to "yes" (with quotes) enables the option in Nextcloud automatically.
COLLABORA_ENABLED="no"          # Setting this to "yes" (with quotes) enables the option in Nextcloud automatically.
FULLTEXTSEARCH_ENABLED="no"          # Setting this to "yes" (with quotes) enables the option in Nextcloud automatically.
IMAGINARY_ENABLED="no"          # Setting this to "yes" (with quotes) enables the option in Nextcloud automatically.
ONLYOFFICE_ENABLED="no"          # Setting this to "yes" (with quotes) enables the option in Nextcloud automatically.
TALK_ENABLED="no"          # Setting this to "yes" (with quotes) enables the option in Nextcloud automatically.
TALK_RECORDING_ENABLED="no"          # Setting this to "yes" (with quotes) enables the option in Nextcloud automatically.
WHITEBOARD_ENABLED="no"          # Setting this to "yes" (with quotes) enables the option in Nextcloud automatically.

APACHE_IP_BINDING=0.0.0.0          # This can be changed to e.g. 127.0.0.1 if you want to run AIO behind a web server or reverse proxy (like Apache, Nginx, Caddy, Cloudflare Tunnel and else) and if that is running on the same host and using localhost to connect
APACHE_MAX_SIZE=17179869184          # This needs to be an integer and in sync with NEXTCLOUD_UPLOAD_LIMIT
APACHE_PORT=1080          # Changing this to a different value than 443 will allow you to run it behind a web server or reverse proxy (like Apache, Nginx, Caddy, Cloudflare Tunnel and else).
COLLABORA_DICTIONARIES="de_DE en_GB en_US es_ES fr_FR it nl pt_BR pt_PT ru"        # You can change this in order to enable other dictionaries for collabora
COLLABORA_SECCOMP_POLICY=--o:security.seccomp=true          # Changing the value to false allows to disable the seccomp feature of the Collabora container.
INSTALL_LATEST_MAJOR=no        # Setting this to yes will install the latest Major Nextcloud version upon the first installation
NEXTCLOUD_ADDITIONAL_APKS=imagemagick        # This allows to add additional packages to the Nextcloud container permanently. Default is imagemagick but can be overwritten by modifying this value.
NEXTCLOUD_ADDITIONAL_PHP_EXTENSIONS=imagick        # This allows to add additional php extensions to the Nextcloud container permanently. Default is imagick but can be overwritten by modifying this value.
NEXTCLOUD_DATADIR=/var/data/ncatomic/nc-aio/nc-files/          # You can change this to e.g. "/mnt/ncdata" to map it to a location on your host. It needs to be adjusted before the first startup and never afterwards!
NEXTCLOUD_MAX_TIME=3600          # This allows to change the upload time limit of the Nextcloud container
NEXTCLOUD_MEMORY_LIMIT=512M          # This allows to change the PHP memory limit of the Nextcloud container
NEXTCLOUD_MOUNT=/var/data/ncatomic/nc-aio/mnt/          # This allows the Nextcloud container to access directories on the host. It must never be equal to the value of NEXTCLOUD_DATADIR!
NEXTCLOUD_STARTUP_APPS="deck twofactor_totp tasks calendar contacts notes"        # Allows to modify the Nextcloud apps that are installed on starting AIO the first time
NEXTCLOUD_TRUSTED_CACERTS_DIR=/etc/ncatomic/nc-aio/ca-certificates          # Nextcloud container will trust all the Certification Authorities, whose certificates are included in the given directory.
NEXTCLOUD_UPLOAD_LIMIT=16G          # This allows to change the upload limit of the Nextcloud container
REMOVE_DISABLED_APPS=yes        # Setting this to no keep Nextcloud apps that are disabled via their switch and not uninstall them if they should be installed in Nextcloud.
TALK_PORT=3478          # This allows to adjust the port that the talk container is using. It should be set to something higher than 1024! Otherwise it might not work!
UPDATE_NEXTCLOUD_APPS="no"          # When setting to "yes" (with quotes), it will automatically update all installed Nextcloud apps upon container startup on saturdays.
EOF
#NC_DOMAIN="localhost"          # TODO! Needs to be changed to the domain that you want to use for Nextcloud.
#NEXTCLOUD_PASSWORD="admin"          # TODO! This is the password of the initially created Nextcloud admin with username "admin".

