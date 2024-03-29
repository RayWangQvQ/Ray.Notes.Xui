#!/usr/bin/env sh
###
 # @Author: Ray
 # @Date: 2022-01-08 15:31:52
 # @LastEditTime: 2022-02-14 00:34:25
 # @LastEditors: Please set LastEditors
 # @Description: enableSSL.sh
 # @FilePath: 
### 
# set -e

echo "Host:$NGINX_HOST"
echo "Email:$TLS_EMAIL"

echo -e "\n----------------更新包----------------"
apt-get update

echo -e "\n----------------安装cron----------------"
apt-get install -y cron
# apt-get install -y crontab crontabs
crontab -l

echo -e "\n----------------安装acme.sh----------------"
curl  https://get.acme.sh | sh -s email=$TLS_EMAIL

echo -e "\n----------------生成证书----------------"
rm /etc/nginx/conf.d/xui_ssl.conf
sed -i 's|\${NGINX_HOST}|'"$NGINX_HOST"'|g' /etc/nginx/conf.d/xui.conf
ls /etc/nginx/conf.d/
cat /etc/nginx/conf.d/xui.conf
nginx -t
nginx -s reload
~/.acme.sh/acme.sh --issue -d $NGINX_HOST --nginx /etc/nginx/conf.d/xui.conf --debug 2

echo -e "\n----------------复制证书----------------"
mkdir /letsencrypt/$NGINX_HOST
~/.acme.sh/acme.sh --install-cert --force -d $NGINX_HOST --key-file /letsencrypt/$NGINX_HOST/privkey.key  --fullchain-file /letsencrypt/$NGINX_HOST/fullchain.crt --reloadcmd "service nginx force-reload"
chmod 777 /letsencrypt/$NGINX_HOST

echo -e "\n----------------新增tls的nginx配置----------------"
cp -f /acme/*.conf /etc/nginx/conf.d/
sed -i 's|\${NGINX_HOST}|'"$NGINX_HOST"'|g' /etc/nginx/conf.d/xui_ssl.conf
cat /etc/nginx/conf.d/xui_ssl.conf
nginx -t
nginx -s reload

echo -e "\n----------------开启acme自动升级----------------"
~/.acme.sh/acme.sh  --upgrade  --auto-upgrade