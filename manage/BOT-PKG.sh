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

if [ $(command -v apt) ];then
    pkg_install="apt install -y"
elif [ $(command -v dnf) ];then
    pkg_install="dnf install -y"
elif [ $(command -v yum) ];then
    pkg_install="yum install -y"
elif [ $(command -v pacman) ];then
    pkg_install="pacman -Syy --noconfirm --needed"
elif [ $(command -v apk) ];then
    pkg_install="apk add"
fi

function pkg_install(){
i=0
until ${pkg_install} ${package}
do
    if [ ${i} -eq 3 ]
        then
            echo -e ${red}错误次数过多 退出${background}
            exit
    fi
    i=$((${i}+1))
    echo -en ${red}命令执行失败 ${green}3秒后重试${background}
    sleep 3s
    echo
done
}

pkg_list=("tar" \
"gzip" \
"pv" \
"redis" \
"wget" \
"curl" \
"unzip" \
"git" \
"dialog")
for package in ${pkg_list[@]}; do
    if ! dpkg -s ${package} >/dev/null 2>&1
    then
        echo -e ${yellow}安装软件 ${package}${background}
        pkg_install
    fi
done

if [ ! -x "/usr/local/bin/ffmpeg" ]
    then
        echo -e ${yellow}安装软件 ffmpeg${background}
        bash <(curl -sL https://gitee.com/baihu433/ffmpeg/raw/master/ffmpeg.sh)
fi

