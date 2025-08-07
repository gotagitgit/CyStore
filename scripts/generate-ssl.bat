@echo off
echo Generating SSL certificates (overwriting existing ones)...

where openssl >nul 2>&1
if %errorlevel% == 0 (
    echo Using local OpenSSL...
    cd ..\nginx\ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout localhost.key -out localhost.crt -subj "/C=US/ST=State/L=City/O=CyStore/CN=localhost"
    cd ..\scripts
) else (
    echo OpenSSL not found, using Docker...
    docker run --rm -v "%cd%\..\nginx\ssl":/certs alpine/openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /certs/localhost.key -out /certs/localhost.crt -subj "/C=US/ST=State/L=City/O=CyStore/CN=localhost"
)

echo SSL certificates generated in nginx/ssl/