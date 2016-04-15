#!/bin/sh

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Load configuration
. /etc/route53/config

# Export access key ID and secret for cli53
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

# Use command line scripts to get instance ID and public hostname
PUBLIC_HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/public-hostname).

# Create a new CNAME record on Route 53, replacing the old entry if nessesary
CMD="$HOST_NAME $TTL CNAME $PUBLIC_HOSTNAME"
/usr/local/bin/cli53 rrcreate --replace "$ZONE" "$CMD"
