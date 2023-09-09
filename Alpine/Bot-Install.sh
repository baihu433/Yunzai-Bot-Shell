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

bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT-PKG.sh)

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
        echo -e ${yellow}安装xz解压工具${background}
        until apk add chromium
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

if ! apk info -e ttf-dejavu >/dev/null 2>&1
    then
        echo -e ${yellow}安装中文字体包${background}
        until apk add ttf-dejavu
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

if ! apk info -e nodejs >/dev/null 2>&1
    then
        echo -e ${yellow}安装软件 Node.JS${background}
        until apk add nodejs
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

if ! apk info -e npm >/dev/null 2>&1
    then
        echo -e ${yellow}安装软件 npm${background}
        until apk add npm
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi
if [ ! -x "$(command -v pnpm)" ];then
    echo -e ${yellow}正在使用npm安装pnpm${background}
    a=0
    npm config set registry https://registry.npmmirror.com
    npm config set registry https://registry.npmmirror.com
    npm install -g npm@latest
    until npm install -g pnpm@latest
    do
      if [ "${a}" == "3" ];then
        echo -e ${red}错误次数过多 退出${background}
        exit
      fi
      echo -e ${red}pnpm安装失败 ${green}正在重试${background}
      a=$(($a+1))
    done
    echo
fi
echo -e ${yellow}正在为pnpm更换默认源${background}
pnpm config set registry https://registry.npmmirror.com
pnpm config set registry https://registry.npmmirror.com
pnpm config set node_sqlite3_binary_host_mirror https://npmmirror.com/mirrors/sqlite3
pnpm config set node_sqlite3_binary_host_mirror https://npmmirror.com/mirrors/sqlite3