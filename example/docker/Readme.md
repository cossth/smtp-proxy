
```bash
docker build -t smtp-relay .

docker run -it --rm \
    -e SMTP_RELAY_HOST="relay.example.com" \
    -e SMTP_RELAY_USERNAME="yourname@yourtenant.onmicrosoft.com" \
    -e SMTP_RELAY_PASSWORD="your_password_or_app_password" \
    -e SMTP_MESSAGE_SIZE_LIMIT=52428800 \
    smtp-relay
```