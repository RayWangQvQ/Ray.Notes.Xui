<!--
 * @Author: Ray
 * @Date: 2022-01-08 13:35:07
 * @LastEditTime: 2022-02-14 00:35:47
 * @LastEditors: Please set LastEditors
 * @Description: README
 * @FilePath: 
-->

# README

## 基础环境正常
- 请先确保服务器已安装好docker和docker compose(v2)环境。
- 请确保已经拥有一个域名(如`xui.test.tk`)，且域名已经DNS到服务器的ip。

## 拷贝文件夹到服务器

## 修改配置并启动容器
修改`docker-compose.yml`中的`NGINX_HOST`（如`xui.test.tk`）和`TLS_EMAIL`配置，在同级目录执行`docker compose up -d`

## 验证面板是否运行
浏览器访问域名（`xui.test.tk`），不带端口（默认80），查看是否可以成功访问面板。

## 开启TLS
在服务器（宿主机）执行`docker exec -it nginx bash /acme/enableSSL.sh`

## 验证TLS
浏览器访问https://xui.test.tk，不带端口（默认443），查看是否正常。

## 添加入站
在面板添加入站时，端口50001到50006可选。

tls的域名输入之前配置的`NGINX_HOST`，公钥输入`/letsencrypt/{域名}/fullchain.crt`，密钥输入`/letsencrypt/{域名}/privkey.key`，注意替换{域名}为真实域名，如`/letsencrypt/xui.test.tk/fullchain.crt`
