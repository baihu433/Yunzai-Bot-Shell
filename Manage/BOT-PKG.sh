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

if [ $(command -v apk) ];then
    pkg_install="apk add --no-cache"
elif [ $(command -v apt) ];then
    pkg_install="apt install -y"
elif [ $(command -v yum) ];then
    pkg_install="yum install -y"
elif [ $(command -v dnf) ];then
    pkg_install="dnf install -y"
elif [ $(command -v pacman) ];then
    pkg_install="pacman -Syy --noconfirm --needed"
fi

function pkg_install(){
i=0
echo -e ${yellow}安装软件 ${pkg}${background}
until ${pkg_install} ${pkg}
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
"tmux")

for package in ${pkg_list[@]}
do
    if [ -x "$(command -v apk)" ];then
        if ! apk info -e "${package}" > /dev/null 2>&1;then
            pkg="${package} ${pkg}"
        fi
    elif [ -x "$(command -v pacman)" ];then
        if ! pacman -Qs "${package}" > /dev/null 2>&1;then
            pkg="${package} ${pkg}" 
        fi
    elif [ -x "$(command -v apt)" ];then
        if ! dpkg -s "${package}" > /dev/null 2>&1;then
            pkg="${package} ${pkg}"
        fi
    elif [ -x "$(command -v yum)" ];then
        if ! yum list installed "${package}" > /dev/null 2>&1;then
            pkg="${package} ${pkg}"
        fi
    elif [ -x "$(command -v dnf)" ];then
        if ! dnf list installed "${package}" > /dev/null 2>&1;then
            pkg="${package} ${pkg}"
        fi
    fi
done

if [ ! -z "${pkg}" ];then
    if [ -x "$(command -v apk)" ];then
        apk update
        pkg_install
    elif [ -x "$(command -v pacman)" ];then
        pkg_install
    elif [ -x "$(command -v apt)" ];then
        apt update
        pkg_install
    elif [ -x "$(command -v yum)" ];then
        yum update
        pkg_install
    elif [ -x "$(command -v dnf)" ];then
        pkg_install
    fi
fi

if [ -x "$(command -v whiptail)" ];then
    dialog_whiptail=whiptail
elif [ -x "$(command -v dialog)" ];then
    dialog_whiptail=dialog
else
    pkg=dialog
    pkg_install
fi

if [ ! -x "$(command -v vim)" ];then
    pkg=vim
    pkg_install
fi
if [ ! -x "$(command -v ffmpeg)" ];then
    if [ ! -x "/usr/local/bin/ffmpeg" ];then
        echo -e ${yellow}安装软件 ffmpeg${background}
        URL=https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT-ARCH.sh
        ffmpeg_static_URL=https://registry.npmmirror.com/-/binary/ffmpeg-static/b6.0
        source <(curl -sL ${URL})
        ffmpeg_URL=${ffmpeg_static_URL}/ffmpeg-linux-${ARCH}
        ffprobe_URL=${ffmpeg_static_URL}/ffprobe-linux-${ARCH}
        wget -O ffmpeg ${ffmpeg_URL}
        wget -O ffprobe ${ffprobe_URL}
        chmod +x ffmpeg ffprobe
        mv -f ffmpeg /usr/local/bin/ffmpeg
        mv -f ffprobe /usr/local/bin/ffprobe
    fi
fi
    