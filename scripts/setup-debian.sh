#!/bin/bash

# Script de instalação do Docker e Fail2Ban no Debian
# Parar a execução em caso de erro
set -e

echo "============================================="
echo " Instalando dependências e Fail2Ban..."
echo "============================================="
sudo apt update
sudo apt install -y ca-certificates curl fail2ban

echo "============================================="
echo " Configurando o Fail2Ban (Proteção SSH)..."
echo "============================================="
# Cria uma configuração local para não sobrescrever a padrão
sudo tee /etc/fail2ban/jail.local > /dev/null <<EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
EOF

sudo systemctl enable fail2ban
sudo systemctl restart fail2ban

echo "============================================="
echo " Instalando o Docker (Repositório Oficial)..."
echo "============================================="
# Adiciona a chave GPG oficial do Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Adiciona o repositório aos sources do Apt
sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Atualiza a lista e instala os pacotes do Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Inicia e habilita o serviço do Docker no boot
sudo systemctl enable docker
sudo systemctl start docker

echo "============================================="
echo " Instalação concluída com sucesso!"
echo " Docker e Fail2Ban estão prontos e rodando."
echo "============================================="
