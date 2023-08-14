for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done
apt install ca-certificates curl gnupg && apt autoremove -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | 
gpg --dearmor -o /etc/apt/keyrings/docker.gpg\n
chmod a+r /etc/apt/keyrings/docker.gpg
echo \\n  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \\n  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \\n  
tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin