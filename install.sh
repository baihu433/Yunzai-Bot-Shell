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

function Script_Install(){
    echo
    echo -e ${white}=========================${background}
    echo -e ${red}" "白狐 ${yellow}BOT ${green}Install ${cyan}Script ${background}
    echo -e "  "————"  "————"  "————"  "————"  "
    echo -e ${green}" "版本:" "v1.0.0 ${cyan}\(20230902\) ${background}
    echo -e ${green}" "作者:" "${cyan}白狐"   "\(baihu433\) ${background}
    echo -e ${white}=========================${background}
    echo
    echo -e ${yellow} - ${yellow}正在安装${background}
    curl -o bh https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/manage/mian.sh
    mv bh /usr/local/bin/bh
    chmod +x /usr/local/bin/bh
    echo -e ${yellow} - ${yellow}安装成功${background}
    echo -e ${yellow} - ${cyan}请使用 ${green}bh ${cyan}命令 打开脚本${background}
}

echo -e ${white}"====="${green}白狐-Script${white}"====="${background}
echo -e ${cyan}白狐 Script 是完全可信的。${background}
echo -e ${cyan}白狐 Script 不会执行任何恶意命令${background}
echo -e ${cyan}白狐 Script 不会执行任何恶意命令${background}
echo -e ${cyan}白狐 Script 不会执行任何恶意命令${background}
echo -e ${cyan}如果您同意安装 请输入 ${green}同意安装${background}
echo -e ${cyan}注意：同意安装即同意本项目的用户协议${background}
echo -e ${cyan}用户协议链接：https://gitee.com/baihu433/Yunzai-Bot-Shell/blob/master/manage/用户协议.txt${background}
echo -e ${white}"=========================="${background}
echo -en ${green}请输入您的选项: ${background};read yn
if [  "yn" == "同意安装" ]
then
    Script_Install
else
    echo -e ${red}终止!! 脚本停止运行${background}
fi
