#!/usr/bin/env bash
set -e
set -u
set -o pipefail

host=""
email=""

while [ $# -ne 0 ]
do
    name="$1"
    case "$name" in
        -t|--host|-[Hh]ost)
            shift
            host="$1"
            ;;
        -m|--mail|-[Mm]ail)
            shift
            email="$1"
            ;;
        -?|--?|-h|--help|-[Hh]elp)
            script_name="$(basename "$0")"
            echo "Ray XUI Installer"
            echo "Usage: $script_name [-t|--host <HOST>] [-m|--mail <MAIL>]"
            echo "       $script_name -h|-?|--help"
            echo ""
            echo "$script_name is a simple command line interface for install XUI."
            echo ""
            echo "Options:"
            echo "  -t,--host <HOST>         Your host, Defaults to \`$host\`."
            echo "      -Host"
            echo "          Possible values:"
            echo "          - xui.test.com"
            echo "  -m,--mail <MAIL>         Your email, Defaults to \`$email\`."
            echo "      -Mail"
            echo "          Possible values:"
            echo "          - mail@qq.com"
            echo "  -?,--?,-h,--help,-Help             Shows this help message"
            echo ""
            exit 0
            ;;
        *)
            say_err "Unknown argument \`$name\`"
            exit 1
            ;;
    esac
    shift
done

if [ -z "$host" ]; then
    read -p "input host:" host
else
    echo "host: $vault_username"
fi

if [ -z "$email" ]; then
    read -p "input email:" email
else
    echo "email: $email"
fi

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