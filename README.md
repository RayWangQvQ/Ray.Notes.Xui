# README

## 基础环境正常
- 请先确保服务器已安装好docker和docker compose(v2)环境。
- 请确保已经拥有一个域名(如`xui.test.tk`)，且域名已经DNS到服务器的ip。

## 开始

```
mkdir -p ./myxui
cd ./myxui
wget https://raw.githubusercontent.com/RayWangQvQ/Ray.Notes.Xui/main/install.sh
chmod +x ./install.sh
./install.sh xui.test.com mail@qq.com
```

其中`xui.test.com`换成自己真实域名，`mail@qq.com`换成自己真实邮箱

## 测试

访问 `http://xui.test.com` 和 `https://xui.test.com`，是否可访问。

xui的默认用户名和密码都是admin，请登录后自行修改。

## 设置节点，添加入站
在面板添加入站时，端口50001到50006可选。

tls的域名输入之前配置的域名，公钥输入`/letsencrypt/{域名}/fullchain.crt`，密钥输入`/letsencrypt/{域名}/privkey.key`，注意替换{域名}为真实域名，如`/letsencrypt/xui.test.tk/fullchain.crt`
