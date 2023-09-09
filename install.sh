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

if [ "$(uname -o)" = "Android" ]; then
	echo "看来你是大聪明 加Q群获取帮助吧 596660282"
	exit 1
fi

if ! [ "$(uname)" == "Linux" ];then
    echo -e ${red}请使用linux!${background}
    exit 0
fi

if [ "$(id -u)" != "0" ]; then
    echo -e ${red} 请使用root用户!${background}
    exit 0
fi
function whiptail_dialog(){
install_dialog(){
echo -e ${green}正在安装必要依赖 dialog${background}
if [ $(command -v apk) ];then
    apk add dialog
elif [ $(command -v apt) ];then
    apt install -y dialog
elif [ $(command -v dnf) ];then
    dnf install -y dialog
elif [ $(command -v yum) ];then
    yum install -y dialog
elif [ $(command -v pacman) ];then
    pacman -Syy --noconfirm --needed dialog
fi
}
if [ -x "$(command -v whiptail)" ];then
    dialog_whiptail=whiptail
elif [ -x "$(command -v dialog)" ];then
    dialog_whiptail=dialog
else
    install_dialog
fi
}


function system_check(){
if grep -q -E -i Alpine /etc/issue && [ -x /sbin/apk ];then
    echo -e ${green}系统效验通过${background}
elif grep -q -E -i Arch /etc/issue && [ -x /usr/bin/pacman ];then
    echo -e ${green}系统效验通过${background}
elif grep -q -E -i Kernel /etc/issue && [ -x /usr/bin/dnf ];then
    echo -e ${green}系统效验通过${background}
elif grep -q -E -i Kernel /etc/issue && [ -x /usr/bin/yum ];then
    echo -e ${green}系统效验通过${background}
elif grep -q -E -i Ubuntu /etc/issue && [ -x /usr/bin/apt ];then
    echo -e ${green}系统效验通过${background}
elif grep -q -E -i Debian /etc/issue && [ -x /usr/bin/apt ];then
    echo -e ${green}系统效验通过${background}
elif grep -q -E -i Kali /etc/issue && [ -x /usr/bin/apt ];then
    echo -e ${green}系统效验通过${background}
elif grep -q -E -i Alpine /etc/os-release && [ -x /sbin/apk ];then
    echo -e ${green}系统效验通过${background}
elif grep -q -E -i Arch /etc/os-release && [ -x /usr/bin/pacman ];then
    echo -e ${green}系统效验通过${background}
elif grep -q -E -i CentOS /etc/os-release && [ -x /usr/bin/dnf ];then
    echo -e ${green}系统效验通过${background}
elif grep -q -E -i CentOS /etc/os-release && [ -x /usr/bin/yum ];then
    echo -e ${green}系统效验通过${background}
elif grep -q -E -i Ubuntu /etc/os-release && [ -x /usr/bin/apt ];then
    echo -e ${green}系统效验通过${background}
elif grep -q -E -i Debian /etc/os-release && [ -x /usr/bin/apt ];then
    echo -e ${green}系统效验通过${background}
elif grep -q -E -i Kali /etc/os-release && [ -x /usr/bin/apt ];then
    echo -e ${green}系统效验通过${background}
else
    echo -e ${red}不受支持的系统${background}
    echo -e ${red}程序终止!! 脚本停止运行${background}
    exit
fi
}
function Script_Install(){
    echo
    echo -e ${white}=========================${background}
    echo -e ${red}" "白狐 ${yellow}BOT ${green}Install ${cyan}Script ${background}
    echo -e "  "————"  "————"  "————"  "————"  "
    echo -e ${green}" "版本:" "v1.0.0 ${cyan}\(20230909\) ${background}
    echo -e ${green}" "作者:" "${cyan}白狐"   "\(baihu433\) ${background}
    echo -e ${white}=========================${background}
    echo
    echo -e ${yellow} - ${cyan}正在安装${background}
    file="/etc/profile"
    bh='alias bh="/usr/local/bin/bh"'
    curl -o bh https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/Mian.sh
    mv -f bh /usr/local/bin/bh
    chmod +x /usr/local/bin/bh
    alias bh="bash /usr/local/bin/bh"
    if grep -q -E bh ${file};then
        sed -i 's#alias bh="/usr/local/bin/bh"##g' ${file}
    else
        echo 'alias bh="/usr/local/bin/bh"' >> ${file}
    fi
    source /etc/profile
    echo
    if ! bh help > /dev/null 2>&1;then
        echo -e ${yellow} - ${red}安装失败${background}
        exit
    fi
    echo -e ${yellow} - ${yellow}安装成功${background}
    echo -e ${yellow} - ${cyan}请使用 ${green}bh ${cyan}命令 打开脚本${background}
}

echo -e ${white}"====="${green}白狐-Script${white}"====="${background}
echo -e ${cyan}白狐 Script ${green}是完全可信的。${background}
echo -e ${cyan}白狐 Script ${yellow}不会执行任何恶意命令${background}
echo -e ${cyan}白狐 Script ${yellow}不会执行任何恶意命令${background}
echo -e ${cyan}白狐 Script ${yellow}不会执行任何恶意命令${background}
echo -e ${cyan}如果您同意安装 请输入 ${green}同意安装${background}
echo -e ${cyan}注意：同意安装即同意本项目的用户协议${background}
echo -e ${cyan}用户协议链接: ${background}
echo -e ${cyan}https://gitee.com/baihu433/Yunzai-Bot-Shell/blob/master/Manage/用户协议.txt${background}
echo -e ${white}"=========================="${background}
echo -en ${green}请输入:${background};read yn
if [  "${yn}" == "同意安装" ]
then
    echo -e ${green}3秒后开始安装${background}
    sleep 2s
    system_check
    whiptail_dialog
    echo
    Script_Install
else
    echo -e ${red}程序终止!! 脚本停止运行${background}
fi
