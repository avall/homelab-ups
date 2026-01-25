#!/bin/bash
eval $(ssh-agent)

# Configura variables para OpenSSH
export SSH_ASKPASS="./ssh-askpass-helper.sh"
export DISPLAY=:0  # Necesario aunque no haya interfaz gráfica

# Añade la clave
ssh-add ~/.ssh/id_github_avall < /dev/null

git config --global user.email "alex.vall.mainou@gmail.com"
git config --global user.name "avall"

git pull
git add .
git add -u .
git commit -am "Self update"
git push