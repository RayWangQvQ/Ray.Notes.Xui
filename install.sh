#!/usr/bin/env bash
set -e
set -u
set -o pipefail

host=""
email=""

host="$1"
email="$2"
echo "host: $host"
echo "email: $email"

# 下载docker-compose文件
echo -e "\n==========下载docker-compose文件=========="
rm -rf ./docker-compose.yml
wget https://raw.githubusercontent.com/RayWangQvQ/Ray.Notes.Xui/main/docker-compose.yml

# 下载xui.conf
echo -e "\n==========下载xui.conf=========="
mkdir -p ./nginx/conf.d
cd ./nginx/conf.d
rm -f xui.conf
wget https://raw.githubusercontent.com/RayWangQvQ/Ray.Notes.Xui/main/nginx/conf.d/xui.conf

# 下载xui_ssl.conf、enableSSL.sh
echo -e "\n==========下载xui_ssl.conf、enableSSL.sh=========="
cd ../
mkdir -p ./acme
cd ./acme
rm -f xui_ssl.conf
wget https://raw.githubusercontent.com/RayWangQvQ/Ray.Notes.Xui/main/nginx/acme/xui_ssl.conf
rm -f enableSSL.sh
wget https://raw.githubusercontent.com/RayWangQvQ/Ray.Notes.Xui/main/nginx/acme/enableSSL.sh

# 替换环境变量
cd ../..
echo -e "\n==========替换docker-compose.yml的host=========="
sed -i 's|- NGINX_HOST=.*|- NGINX_HOST='"$host"'|g' ./docker-compose.yml
echo -e "\n==========替换docker-compose.yml的email=========="
sed -i 's|- TLS_EMAIL=.*|- TLS_EMAIL='"$email"'|g' ./docker-compose.yml
cat ./docker-compose.yml

echo -e "\n==========启动http站点=========="
sed -i 's|\${NGINX_HOST}|'"$host"'|g' ./nginx/conf.d/xui.conf
rm -rf ./nginx/conf.d/xui_ssl.conf
cat ./nginx/conf.d/xui.conf
docker compose down
docker compose up -d
docker ps

echo -e "\n==========启动https站点=========="
docker exec -it nginx bash /acme/enableSSL.sh