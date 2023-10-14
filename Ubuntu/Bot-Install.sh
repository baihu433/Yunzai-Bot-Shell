#!/bin/env bash

export red="\033[31m"
export green="\033[32m"
export yellow="\033[33m"
export blue="\033[34m"
export purple="\033[35m"
export cyan="\033[36m"
export white="\033[37m"
export background="\033[0m"

bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT-PKG.sh)

if ! dpkg -s xz-utils >/dev/null 2>&1
    then
        echo -e ${yellow}安装xz解压工具${background}
        until apt install -y xz-utils
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

if ! dpkg -s chromium-browser >/dev/null 2>&1
    then
        echo -e ${yellow}安装chromium浏览器${background}
        until bash <(curl -sL https://gitee.com/baihu433/chromium/raw/master/chromium.sh)
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

if ! dpkg -s fonts-wqy-zenhei fonts-wqy-microhei >/dev/null 2>&1
    then
        echo -e ${yellow}安装中文字体包${background}
        until apt install -y fonts-wqy*
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

function node_install(){
until wget -O node.tar.xz -c https://cdn.npmmirror.com/binaries/node/latest-${version1}.x/node-${version2}-linux-${ARCH}.tar.xz
do
    if [[ ${i} -eq 3 ]]
    then
        echo -e ${red}错误次数过多 退出${background}
        exit
    fi
    i=$((${i}+1))
    echo -e ${red}安装失败 3秒后重试${background}
    sleep 3s
done
bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT-NODE.JS.sh)
}

if [ -x "$(command -v node)" ]
then
    Nodsjs_Version=$(node -v | cut -d '.' -f1)
fi

if ! [[ "$Nodsjs_Version" == "v16" || "$Nodsjs_Version" == "v18" ]];then
    echo -e ${yellow}安装软件 Node.JS${background}
    source <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT-ARCH.sh)
    if awk '{print $2}' /etc/issue | grep -q -E 22.*
        then
            version1=v18
            version2=v18.17.0
            node_install
    elif awk '{print $2}' /etc/issue | grep -q -E 23.*
        then
            version1=v18
            version2=v18.17.0
            node_install
    elif awk '{print $2}' /etc/issue | grep -q -E 24.*
        then
            version1=v18
            version2=v18.17.0
            node_install
    else
            version1=v16
            version2=v16.20.0
            node_install
    fi
fi