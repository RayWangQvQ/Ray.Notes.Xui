#!/usr/bin/env bash
set -e
set -u
set -o pipefail

host=""
email=""

while [ $# -ne 0 ]
do
    host="$1"
    email="$2"
    echo "host:$host"
    echo "email:$email"
done

# 下载docker-compose
echo -e "\n下载docker-compose"
wget https://raw.githubusercontent.com/RayWangQvQ/Ray.Notes.Xui/main/docker-compose.yml

# 下载xui.conf
echo -n "\n下载xui.conf"
mkdir -p ./conf.d
cd ./conf.d
wget https://raw.githubusercontent.com/RayWangQvQ/Ray.Notes.Xui/main/nginx/conf.d/xui.conf

# 下载xui_ssl.conf、enableSSL.sh
echo -e "\n下载xui_ssl.conf、enableSSL.sh"
cd ..
wget https://raw.githubusercontent.com/RayWangQvQ/Ray.Notes.Xui/main/nginx/acme/xui_ssl.conf
wget https://raw.githubusercontent.com/RayWangQvQ/Ray.Notes.Xui/main/nginx/acme/enableSSL.sh

# 替换环境变量
echo -e "\n替换host"
sed -i 's|- NGINX_HOST=|- NGINX_HOST='"$host"'|g' ./docker-compose.yml
echo -e "\n替换email"
sed -i 's|- TLS_EMAIL=|- TLS_EMAIL='"$email"'|g' ./docker-compose.yml
cat ./docker-compose.yml

echo -e "\n启动http站点"
docker compose up -d

echo -e "\n启动https站点"
docker exec -it nginx bash /acme/enableSSL.sh