# SSL Certificate Setup

## Generate SSL Certificates

Before running the application, generate SSL certificates:

```cmd
scripts\generate-ssl.bat
```

This creates self-signed certificates in `nginx/ssl/` for HTTPS access at `https://localhost:8081`.