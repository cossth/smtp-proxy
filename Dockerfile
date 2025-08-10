FROM alpine:3.22

RUN apk add --no-cache msmtp ca-certificates dumb-init bash && update-ca-certificates

# Environment variables
ENV SMTP_MESSAGE_SIZE_LIMIT=52428800 \
    SMTP_RELAY_HOST=smtp.example.com \
    SMTP_RELAY_MYHOSTNAME=relay.local \
    SMTP_RELAY_MYNETWORKS="127.0.0.0/8 ::1/128" \
    SMTP_RELAY_USERNAME="" \
    SMTP_RELAY_PASSWORD=""


# Create msmtp config template
RUN mkdir -p /etc/msmtp /var/log/msmtp && touch /var/log/msmtp/msmtp.log

# Entry script to generate msmtp config
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# Default command: keep container running
CMD ["tail", "-f", "/var/log/msmtp/msmtp.log"]
