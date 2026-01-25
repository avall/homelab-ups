# homelab-ups
Configure UPS Salicru SPS/Home 1000va / 600w


Project folders
```
nutify-docker/
├── docker-compose.yml
├── scripts/
│   ├── nutnotify.sh
│   └── nut-remote-shutdown.sh
└── nutify/  # Se crean automáticamente
    ├── logs/
    ├── instance/
    ├── ssl/
    └── etc/nut/
```

- Before run `docker compose up -d` we must create the private keys to shut down machines remotely using `ssh` without passwords.
```bash
# Create keys in machine where we are going to run docker compose. This machine must be connected via USB cable to the UPS.
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""

# Copy to all devices that we will shoutdown remotely.
ssh-copy-id <user>@<ip>
```
