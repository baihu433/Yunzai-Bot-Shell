#!/bin/env bash
cd $HOME
export red="\033[31m"
export green="\033[32m"
export yellow="\033[33m"
export blue="\033[34m"
export purple="\033[35m"
export cyan="\033[36m"
export white="\033[37m"
export background="\033[0m"

bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/manage/BOT-PKG.sh)

if ! apk info -e xz >/dev/null 2>&1
    then
        echo -e ${yellow}安装xz解压工具${background}
        until apk add xz
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

if ! apk info -e chromium >/dev/null 2>&1
    then
        echo -e ${yellow}安装chromium浏览器${background}
        until apk add chromium
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

if ! apk info -e ttf-dejavu && apk info -e wqy-zenhei >/dev/null 2>&1
    then
        echo -e ${yellow}安装中文字体包${background}
        until apk add ttf-dejavu wqy-zenhei
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

if [ -x "$(command -v node)" ]
then
    echo -e ${yellow}安装软件 Node.JS${background}
    Nodsjs_Version=$(node -v | cut -d '.' -f1)
fi
if ! [[ "$Nodsjs_Version" == "v16" || "$Nodsjs_Version" == "v18" ]];then
    source <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/manage/BOT-ARCH.sh)
    until wget -q --show-progress -O node.tar.xz -c https://cdn.npmmirror.com/binaries/node/latest-v18.x/node-v18.17.0-linux-${ARCH}.tar.xz
    do
        if [ ${i} -eq 3 ]
        then
            echo -e ${red}错误次数过多 退出${background}
            exit
        fi
        i=$((${i}+1))
        echo -e ${red}安装失败 3秒后重试${background}
        sleep 3s
    done
    bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/manage/BOT-NODE.JS.sh)
fi
