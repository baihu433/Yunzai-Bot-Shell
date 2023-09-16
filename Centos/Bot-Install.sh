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

if [ $(command -v dnf) ];then
    pkg_install="dnf"
elif [ $(command -v yum) ];then
    pkg_install="yum"
fi

bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT-PKG.sh)

if ! ${pkg_install} list installed xz >/dev/null 2>&1
    then
        echo -e ${yellow}安装xz解压工具${background}
        until ${pkg_install} install -y xz
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done
fi

if ! ${pkg_install} list installed chromium >/dev/null 2>&1
    then
        echo -e ${yellow}安装chromium浏览器${background}
        until ${pkg_install} install -y chromium
        do
            echo -e ${red}安装失败 3秒后重试${background}
            sleep 3s
        done    
fi

if ! ${pkg_install} list installed fonts >/dev/null 2>&1
    then
        echo -e ${yellow}安装中文字体${background}
        until ${pkg_install} groupinstall -y fonts
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
i=0
if ! [[ "$Nodsjs_Version" == "v16" || "$Nodsjs_Version" == "v18" ]];then
    source <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT-ARCH.sh)
    rm -rf node.tar.xz
    until wget -q --show-progress -O node.tar.xz -c https://cdn.npmmirror.com/binaries/node/latest-v18.x/node-v18.17.0-linux-${ARCH}.tar.xz
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
fi
