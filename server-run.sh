#original 
# https://github.com/treyyoder/quakejs-docker?tab=readme-ov-file


apt-get -y update
apt-get -y upgrade
apt-get -y install podman ufw

podman build --tag q3js:latest -f Dockerfile .

podman run -d --rm --name quakejs -e SERVER=0.0.0.0 -e HTTP_PORT=8383 -p 8383:80 -p 27960:27960 localhost/q3js

ufw allow 22/tcp                    # SSH
ufw allow 80                        # HTTP
ufw allow 443                       # HTTPS (if needed)

# quake ports
ufw allow 8383
ufw allow 27960
# needed to allow access to container
ufw default allow FORWARD
