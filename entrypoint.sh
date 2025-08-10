#!/bin/bash
set -e

# Write msmtp config
cat > /etc/msmtp/msmtprc <<EOF
defaults
auth           on
tls            on
tls_starttls   on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        /var/log/msmtp/msmtp.log

account        default
host           ${SMTP_RELAY_HOST}
port           587
from           ${SMTP_RELAY_USERNAME}
user           ${SMTP_RELAY_USERNAME}
password       ${SMTP_RELAY_PASSWORD}
EOF

if [ -n "$SMTP_MESSAGE_SIZE_LIMIT" ]; then
    echo "size_limit $SMTP_MESSAGE_SIZE_LIMIT" >> /etc/msmtp/msmtprc
fi

chmod 600 /etc/msmtp/msmtprc

echo "✅ msmtp configured for ${SMTP_RELAY_HOST}"
exec "$@"