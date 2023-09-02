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

function dpkg_install(){
if [ ! -x "$(command -v dpkg)" ]
then
    echo -e ${yellow}安装软件 Node.JS${background}
    Nodsjs_Version=$(node -v | cut -d '.' -f1)
fi
}

function Script(){
if grep -q -E Alpine /etc/issue && [ -x /sbin/apk ];then
    
elif grep -q -E Arch /etc/issue && [ -x /usr/bin/pacman ];then
    
elif grep -q -E Kernel /etc/issue && [ -x /usr/bin/dnf ];then
    
elif grep -q -E Kernel /etc/issue && [ -x /usr/bin/yum ];then
    
elif grep -q -E Ubuntu /etc/issue && [ -x /usr/bin/apt ];then
    
elif grep -q -E Debian /etc/issue && [ -x /usr/bin/apt ];then
    
fi
}

echo -e ${white}"====="${green}白狐-Script${white}"====="${background}
echo -e ${cyan}白狐 Script 是完全可信的。${background}
echo -e ${cyan}白狐 Script 不会执行任何恶意命令${background}
echo -e ${cyan}白狐 Script 不会执行任何恶意命令${background}
echo -e ${cyan}白狐 Script 不会执行任何恶意命令${background}
echo -e ${cyan}如果您同意安装 请输入 ${green}同意安装${background}
echo -e ${white}"=========================="${background}
echo -en ${green}请输入您的选项: ${background};read yn
if [  "yn" == "同意安装" ]
then
    if [ ! -x "$(command -v dpkg)" ]
    then
        echo -e ${yellow}安装软件 dpkg${background}
        dpkg_install
        Script
    fi
else
    echo -e ${red}终止!! 脚本停止运行${background}
fi
