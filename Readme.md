# SMTP Relay
This Docker image provides a lightweight SMTP relay service using msmtp for sending emails via SMTP server that supports STARTTLS and authentication.

## Features
* Lightweight Alpine-based image
* STARTTLS and TLS encryption enabled by default
* Configurable via environment variables
* Works with Office 365 and other SMTP providers
* Restricts allowed networks for relay to improve security


## Environment Variables

| Variable                       | Description                                                                    | Example                      |
| ------------------------------ | ------------------------------------------------------------------------------ | ---------------------------- |
| **SMTP_MESSAGE_SIZE_LIMIT** | Maximum email size (in bytes) allowed by the relay                             | `52428800`                   |
| **SMTP_RELAY_HOST**          | Upstream SMTP relay host and port                                              | `smtp.office365.com:587`     |
| **SMTP_RELAY_MYHOSTNAME**    | Hostname to be used in the relay's HELO/EHLO                                   | `relay.example.com`          |
| **SMTP_RELAY_MYNETWORKS**    | Comma-separated list of networks allowed to relay emails                       | `10.0.0.0/8, 192.168.0.0/16` |
| **SMTP_RELAY_USERNAME**      | SMTP relay authentication username (usually your email address for Office 365) | `user@example.com`           |
| **SMTP_RELAY_PASSWORD**      | SMTP relay authentication password or application-specific password            | `yourpassword`               |

---

## Example `docker run`

```bash
docker run -d --name smtp-relay \
  -e SMTP_MESSAGE_SIZE_LIMIT=52428800 \
  -e SMTP_RELAY_HOST="smtp.office365.com:587" \
  -e SMTP_RELAY_MYHOSTNAME="relay.example.com" \
  -e SMTP_RELAY_MYNETWORKS="10.0.0.0/8, 192.168.0.0/16" \
  -e SMTP_RELAY_USERNAME="user@example.com" \
  -e SMTP_RELAY_PASSWORD="yourpassword" \
  -p 2525:2525 \
  ghcr.io/cossth/smtp-proxy:main
```

---

## Example `docker-compose.yml`
Please see [docker-compose.yaml](./example/docker-compose/docker-compose.yaml)

```yaml
version: '3.8'
services:
  smtp-relay:
    image: ghcr.io/cossth/smtp-proxy:main
    container_name: smtp-relay
    ports:
      - "2525:2525"
    environment:
      SMTP_MESSAGE_SIZE_LIMIT: 52428800
      SMTP_RELAY_HOST: "smtp.office365.com:587"
      SMTP_RELAY_MYHOSTNAME: "relay.example.com"
      SMTP_RELAY_MYNETWORKS: "10.0.0.0/8, 192.168.0.0/16"
      SMTP_RELAY_USERNAME: "user@example.com"
      SMTP_RELAY_PASSWORD: "yourpassword"
    restart: unless-stopped
```

## Example `Flux/Kustomization`
You can add below configs in your cluster to deploy the smtp-relay.

[Kustomization Files](./example/kubernetes)

```bash
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: cossth
spec:
  interval: 24h
  url: https://github.com/cossth/smtp-proxy
  ref:
    branch: main
---
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: smtp-proxy
  namespace: flux-system
spec:
  interval: 10m
  path: ./example/kubernetes
  prune: true
  sourceRef:
    kind: GitRepository
    name: cossth
```

## Security Notes

* Restrict `SMTP_RELAY_MYNETWORKS` to trusted IP ranges (e.g., your Kubernetes cluster network or your Docker network).
* Use **application-specific passwords** where possible.


## Testing the Relay

You can test by connecting via `telnet` or using a mail client:
> Please note your ip should be allowed in `SMTP_RELAY_MYNETWORKS`.

```bash
telnet localhost 25
EHLO test
MAIL FROM:<your@email.com>
RCPT TO:<recipient@email.com>
DATA
Subject: Test Email
This is a test.
.
QUIT
```
