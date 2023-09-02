#!/bin/env bash

if [ ! -x "$(command -v xz)" ]
then
    echo -e ${yellow}安装软件 xz${background}
    apt install -y xz-utils
fi

bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/BOT-PKG.sh)

if ! dpkg -s chromium-browser >/dev/null 2>&1
        then
            until bash <(curl -sL https://gitee.com/baihu433/chromium/raw/master/chromium.sh)
            do
                echo -e ${red}安装失败 3秒后重试${background}
                sleep 3s
            done
fi

Nodsjs_Version=$(node -v | cut -d '.' -f1)
if ! [[ "$Nodsjs_Version" == "v16" || "$Nodsjs_Version" == "v18" ]];then
if awk '{print $2}' /etc/issue | grep -q -E 22.*
    then
        wget -q --show-progress -O node.tar.xz -c https://cdn.npmmirror.com/binaries/node/latest-v18.x/node-v18.17.0-linux-${ARCH}.tar.xz
elif awk '{print $2}' /etc/issue | grep -q -E 23.*
    then
        wget -q --show-progress -O node.tar.xz -c https://cdn.npmmirror.com/binaries/node/latest-v18.x/node-v18.17.0-linux-${ARCH}.tar.xz     
else
        wget -q --show-progress -O node.tar.xz -c https://cdn.npmmirror.com/binaries/node/latest-v16.x/node-v16.20.0-linux-${ARCH}.tar.xz
fi