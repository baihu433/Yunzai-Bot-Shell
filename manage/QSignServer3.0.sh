#!/bin/env bash
export red="\033[31m"
export green="\033[32m"
export yellow="\033[33m"
export blue="\033[34m"
export purple="\033[35m"
export cyan="\033[36m"
export white="\033[37m"
export background="\033[0m"
cd $HOME
if [ "$(uname -o)" = "Android" ];then
echo -e ${red}你是大聪明吗?${background}
exit
fi
if [ ! "$(uname)" = "Linux" ]; then
	echo -e ${red}你是大聪明吗?${background}
    exit
fi
if [ ! "$(id -u)" = "0" ]; then
    echo -e ${red}请使用root用户${background}
    exit 0
fi
QSIGN_URL="https://gitee.com/baihu433/unidbg-fetch-qsign/releases/download/1.1.9/unidbg-fetch-qsign-1.1.9.zip"
QSIGN_VERSION="119"
qsign_version="1.1.9"
txlib="https://gitee.com/baihu433/txlib"
case $(uname -m) in
amd64|x86_64)
JDK_URL="https://mirrors.tuna.tsinghua.edu.cn/Adoptium/8/jdk/x64/linux/OpenJDK8U-jdk_x64_linux_hotspot_8u382b05.tar.gz"
node=x64
;;
arm64|aarch64)
JDK_URL="https://mirrors.tuna.tsinghua.edu.cn/Adoptium/8/jdk/aarch64/linux/OpenJDK8U-jdk_aarch64_linux_hotspot_8u382b05.tar.gz"
node=arm64
;;
esac
if [ -d $HOME/QSignServer/jdk ];then
export PATH=$PATH:$HOME/QSignServer/jdk/bin
export JAVA_HOME=$HOME/QSignServer/jdk
fi
if [ -d /usr/local/node/bin ];then
    if [ ! -d $HOME/.local/share/pnpm ];then
        mkdir -p $HOME/.local/share/pnpm
    fi
    export PATH=$PATH:$HOME/.local/share/pnpm
    export PNPM_HOME=$HOME/.local/share/pnpm
elif [ -d $HOME/QSignServer/node/bin ];then
    export PATH=$PATH:$HOME/QSignServer/node/bin
    export PNPM_HOME=$HOME/QSignServer/node/bin
elif [ -d /usr/lib/node_modules/pnpm/bin ];then
    if [ ! -d $HOME/.local/share/pnpm ];then
        mkdir -p $HOME/.local/share/pnpm
    fi
    export PATH=$PATH:$HOME/.local/share/pnpm
    export PNPM_HOME=$HOME/.local/share/pnpm
fi
function install_QSignServer(){
if [ ! -e /etc/resolv.conf ]; then
    echo -e ${red}没有resolv.conf此文件${background}
    exit
fi
if ! grep -q "114.114.114.114" /etc/resolv.conf && grep -q "8.8.8.8" /etc/resolv.conf ;then
    cp -f /etc/resolv.conf /etc/resolv.conf.backup
    echo -e ${yellow}DNS已备份至 /etc/resolv.conf.backup${background}
    echo "nameserver 114.114.114.114" > /etc/resolv.conf
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
    echo -e ${yellow}DNS已修改为 114.114.114.114 8.8.8.8${background}
fi
if [ ! $(command -v git) ] || [ ! $(command -v wget) ] || [ ! $(command -v gzip) ] || [ ! $(command -v unzip) ] || [ ! $(command -v xz) ] || [ ! $(command -v tar) ] || [ ! $(command -v pv) ];then
    if [ $(command -v apt) ];then
        apt update -y
        apt install -y git wget gzip unzip xz-utils tar pv
    elif [ $(command -v yum) ];then
        yum update -y
        yum install -y git wget gzip unzip xz tar pv
    elif [ $(command -v dnf) ];then
        dnf update -y
        dnf install -y git wget gzip unzip xz pv
    elif [ $(command -v pacman) ];then
        pacman -Sy --noconfirm --needed git wget gzip unzip xz tar pv
    elif [ $(command -v apk) ];then
        apk update
        apk add git wget gzip unzip xz tar pv
    fi
fi
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
if [[ ! "${JAVA_VERSION}" == "1.8*"* ]]; then
    rm -rf $HOME/QSignServer/jdk > /dev/null
    until wget -q --show-progress -O jdk.tar.gz -c ${JDK_URL}
    do
      echo -e ${red}下载失败 ${green}正在重试${background}
    done
    if [ ! -d $HOME/QSignServer ];then
        mkdir QSignServer
    fi
    rm -rf QSignServer/jdk 2&> /dev/null
    echo -e ${yellow}正在解压JDK文件,请耐心等候${background}
    mkdir jdk
    pv jdk.tar.gz | tar -zxf - -C jdk
    mv jdk/$(ls jdk) QSignServer/jdk
    rm -rf jdk.tar.gz
    rm -rf jdk
    PATH=$PATH:$HOME/QSignServer/jdk/bin
    export JAVA_HOME=$HOME/QSignServer/jdk
fi
NODEJS_URL16=https://cdn.npmmirror.com/binaries/node/latest-v16.x/node-v16.20.0-linux-${node}.tar.xz
NODEJS_URL18=https://cdn.npmmirror.com/binaries/node/latest-v18.x/node-v18.17.0-linux-${node}.tar.xz
Nodsjs_Version=$(node -v | cut -d '.' -f1)
if ! [[ "$Nodsjs_Version" == "v16" || "$Nodsjs_Version" == "v18" ]]
    then
    if awk '{print $2}' /etc/issue | grep -q -E 22.*
        then
            curl -o node.tar.xz ${NODEJS_URL18}
    elif awk '{print $2}' /etc/issue | grep -q -E 23.*
        then
            curl -o node.tar.xz ${NODEJS_URL18}
    else
            curl -o node.tar.xz ${NODEJS_URL16}
    fi
    if [ ! -d node ];then
    mkdir node
    fi
    echo -e ${yellow}正在解压nodejs二进制文件压缩包${background}
    rm -rf $HOME/QSignServer/node
    pv node.tar.xz | tar -xJf - -C node
    mv -f node/$(ls node) $HOME/QSignServer/node
    rm -rf node.tar.xz
    rm -rf node
    export PATH=$PATH:$HOME/QSignServer/node/bin
    export PNPM_HOME=$HOME/QSignServer/node/bin
fi
if ! [ -x "$(command -v pnpm)" ];then
    echo -e ${yellow}正在使用npm安装pnpm${background}
    a=0
    npm config set registry https://registry.npmmirror.com
    npm config set registry https://registry.npmmirror.com
    npm install -g npm@latest
    until npm install -g pnpm@latest
    do
      echo -e ${red}pnpm安装失败 ${green}正在重试${background}
      a=$(($a+1))
      if [ "${a}" == "3" ];then
        echo -e ${red}错误次数过多 退出${background}
        exit
      fi
    done
    echo
fi
if ! [ -x "$(command -v pm2)" ];then
    echo -e ${yellow}正在使用pnpm安装pm2${background}
    pnpm config set registry https://registry.npmmirror.com
    pnpm config set registry https://registry.npmmirror.com
    until pnpm install -g pm2@latest
    do
      echo -e ${red}pm2安装失败 ${green}正在重试${background}
      pnpm setup
      source /root/.bashrc
    done
    echo
fi
if [[ -d $HOME/QSignServer/qsign* ]];then
echo -e ${yellow}您已安装过签名服务器 请使用更新${background}
exit
fi
git clone --depth=1 ${txlib}
rm -rf txlib/.git txlib/README.md
rm -rf $HOME/QSignServer/txlib > /dev/null
mv -f txlib $HOME/QSignServer/txlib
until wget -q --show-progress -O qsign.zip -c ${QSIGN_URL}
do
    echo -e ${red}下载失败 3秒后重试${background}
done
echo -e ${yellow}正在解压签名服务器压缩包${background}
pv qsign.zip | unzip -q qsign.zip -d qsign
rm -rf qsign.zip
mv qsign/* $HOME/QSignServer/qsign${QSIGN_VERSION}
rm -rf qsign
API_LINK=["${cyan} ${qsign_version}"]
port_=5200
key_=fox
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    port="$(grep -E port ${file} | awk '{print $2}' | sed "s/\"//g" | sed "s/://g" )"
    sed -i "s/${port}/${port_}/g" ${file}
done
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    key="$(grep -E key ${file} | awk '{print $2}' | sed "s/\"//g" | sed "s/,//g" )"
    sed -i "s/${key}/${key_}/g" ${file}
done
if [ ! "${install_QSignServer}" == "true" ]
then
echo -en ${yellow}安装完成 是否启动?[Y/n]${background};read yn
case ${yn} in
Y|y)
start_QSignServer
;;
esac
fi
}
function start_QSignServer(){
if ! [ -x "$(command -v pm2)" ];then
    echo -e ${yellow}正在使用pnpm安装pm2${background}
    pnpm config set registry https://registry.npmmirror.com
    pnpm config set registry https://registry.npmmirror.com
    until pnpm install -g pm2@latest
    do
      echo -e ${red}pm2安装失败 ${green}正在重试${background}
      pnpm setup
      source /root/.bashrc
    done
    echo
fi
echo -e ${white}"====="${green}白狐-QSignServer${white}"====="${background}
echo -e ${cyan}请选择您想让您签名服务器适配的QQ版本${background}
echo -e  ${green}1.  ${cyan}HD: 8.9.58${background}
echo -e  ${green}2.  ${cyan}HD: 8.9.63${background}
echo -e  ${green}3.  ${cyan}HD: 8.9.68${background}
echo -e  ${green}4.  ${cyan}HD: 8.9.70${background}
echo -e  ${green}5.  ${cyan}HD: 8.9.71${background}
echo -e  ${green}6.  ${cyan}HD: 8.9.73${background}
echo -e  ${green}7.  ${cyan}HD: 8.9.76${background}
echo -e  ${green}8.  ${cyan}TIM: 3.5.1${background}
echo -e  ${green}9.  ${cyan}TIM: 3.5.2${background}
echo "========================="
echo -en ${green}请输入您的选项: ${background};read num
case ${num} in
1|8.9.58)
export version=8.9.58
;;
2|8.9.63)
export version=8.9.63
;;
3|8.9.68)
export version=8.9.68
;;
4|8.9.70)
export version=8.9.70
;;
5|8.9.71)
export version=8.9.71
;;
6|8.9.73)
export version=8.9.73
;;
7|8.9.76)
export version=8.9.76
;;
8|5.3.1)
export version=3.5.1
;;
9|5.3.2)
export version=3.5.2
;;
*)
echo
echo -e ${red}输入错误${background}
exit
;;
esac
if [ ! -d $HOME/QSignServer/qsign${QSIGN_VERSION} ];then
echo -e ${yellow}您未安装过该版本的签名服务器${background}
exit
fi
if ! pm2 show qsign${QSIGN_VERSION} | grep -q online ;then
    pm2 start --name qsign${QSIGN_VERSION} "bash $HOME/QSignServer/qsign${QSIGN_VERSION}/bin/unidbg-fetch-qsign --basePath=$HOME/QSignServer/txlib/${version}"
    echo
    echo -en ${yellow}签名服务器已经启动,是否打开日志 [Y/n]${background};read num
    case $num in
     Y|y)
       pm2 logs qsign${QSIGN_VERSION}
       echo
       ;;
       esac
else
    echo -en ${yellow}签名服务器已经启动,是否打开日志 [Y/n]${background};read num
      case $num in
     Y|y)
       pm2 logs qsign${QSIGN_VERSION}
       echo
       ;;
       esac  
fi
echo -en ${yellow}回车返回${background};read
}

function stop_QSignServer(){
echo -e ${yellow}正在停止服务器运行${background}
pm2 stop qsign${QSIGN_VERSION}
pm2 delete qsign${QSIGN_VERSION}
echo -en ${yellow}停止完成 回车返回${background};read
}

function restart_QSignServer(){
pm2 restart qsign${QSIGN_VERSION}
echo -en ${yellow}重启完成 回车返回${background};read
}

function update_QSignServer(){
echo -e ${yellow}正在停止服务器运行${background}
pm2 stop qsign*
pm2 delete qsign*
echo -e ${yellow}正在更新签名服务器${background}
rm -rf $HOME/QSignServer/qsign* > /dev/null
rm -rf $HOME/QSignServer/txlib > /dev/null
rm -rf qsign.zip txlib
git clone --depth=1 ${txlib}
rm -rf txlib/.git txlib/README.md
mv -f txlib $HOME/QSignServer/txlib
until wget -q --show-progress -O qsign.zip -c ${QSIGN_URL}
do
    echo -e ${red}下载失败 3秒后重试${background}
done
pv qsign.zip | unzip -q qsign.zip -d qsign
rm -rf qsign.zip
mv qsign/$(ls qsign) $HOME/QSignServer/qsign${QSIGN_VERSION}
rm -rf qsign
port_=5200
key_=fox
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    port="$(grep -E port ${file} | awk '{print $2}' | sed "s/\"//g" | sed "s/://g" )"
    sed -i "s/${port}/${port_}/g" ${file}
done
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    key="$(grep -E key ${file} | awk '{print $2}' | sed "s/\"//g" | sed "s/,//g" )"
    sed -i "s/${key}/${key_}/g" ${file}
done
echo -en ${yellow}更新完成 回车返回${background};read
}

function uninstall_QSignServer(){
cd $HOME
echo -e ${yellow}正在停止服务器运行${background}
pm2 stop qsign${QSIGN_VERSION}
pm2 delete qsign${QSIGN_VERSION}
rm -rf $HOME/QSignServer 2&> /dev/null
rm -rf $HOME/QSignServer 2&> /dev/null
Version="${red}[未部署]"
}

function key_QSignServer(){
echo -en ${green}请输入更改后的key: ${background};read key_
if [ -z "${key_}" ]; then
    echo -en ${red}输入错误 回车返回${background};read
    return
fi
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    key="$(grep -E key ${file} | awk '{print $2}' | sed "s/\"//g" | sed "s/,//g" )"
    sed -i "s/${key}/${key_}/g" ${file}
done
echo -en ${yellow}更改完成 回车返回${background};read
}

function port_QSignServer(){
echo -en ${green}请输入更改后的端口号: ${background};read port_
if [ -z "${port_}" ]; then
    echo -en ${red}输入错误 回车返回${background};read
    return
fi
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    port="$(grep -E port ${file} | awk '{print $2}' | sed "s/\"//g" | sed "s/://g" )"
    sed -i "s/${port}/${port_}/g" ${file}
done
echo -en ${yellow}更改完成 回车返回${background};read
}

function link_QSignServer(){
if [ ! -d $HOME/QSignServer/qsign${QSIGN_VERSION} ];then
    echo -en ${red}您还没有部署签名服务器!!! ${cyan}回车返回${background};read
    return
fi
echo -e ${green}您的各版本API链接${background}
echo
for folder in $(ls $HOME/QSignServer/txlib)
do
file="$HOME/QSignServer/txlib/${folder}/config.json"
port="$(grep -E port ${file} | awk '{print $2}' | sed "s/\"//g" | sed "s/://g" )"
key="$(grep -E key ${file} | awk '{print $2}' | sed "s/\"//g" | sed "s/,//g" )"
host="$(grep -E host ${file} | awk '{print $2}' | sed "s/\"//g" | sed "s/,//g" )"
echo -e ${green}${folder}: ${cyan}"http://""${host}":"${port}"/sign?key="${key}"${background}
echo
done
echo -en ${yellow}回车返回${background};read
}

function help_QSignServer(){
echo -e ${green}1. ${cyan}先启动签名服务器,再写入签名服务器地址,最后启动机器人${background}
echo -e ${green}2. ${cyan}已经启动签名服务器,然后才能使用重启签名服务器,不然请使用启动签名服务器${background}

echo -en ${yellow}回车返回${background};read
}

function main(){
if [ -d $HOME/QSignServer/qsign${QSIGN_VERSION} ];then
    if pm2 show qsign${QSIGN_VERSION} | grep -q online;then
        condition="${cyan}[已启动]"
    else
        condition="${red}[未启动]"
    fi
fi

if [[ -d $HOME/QSignServer ]];then  
        Version="[$(ls $HOME/QSignServer | grep qsign | sed "s/qsign//g" | sed "s/.\B/&./g")]"
        if [ "${QSIGN_VERSION}" = $(ls $HOME/QSignServer | grep qsign | sed "s/qsign//g") ]
        then
        Version="${cyan}${Version}"
        else
            Version="${red}${Version} [请更新]"
        fi
else
        Version="${red}[未部署]"
fi

echo -e ${white}"====="${green}白狐-QSignServer${white}"====="${background}
echo -e  ${green}1.  ${cyan}安装签名服务器${background}
echo -e  ${green}2.  ${cyan}启动签名服务器${background}
echo -e  ${green}3.  ${cyan}关闭签名服务器${background}
echo -e  ${green}4.  ${cyan}重启签名服务器${background}
echo -e  ${green}5.  ${cyan}更新签名服务器${background}
echo -e  ${green}6.  ${cyan}卸载签名服务器${background}
echo -e  ${green}7.  ${cyan}修改签名服务器key值${background}
echo -e  ${green}8.  ${cyan}修改签名服务器端口${background}
echo -e  ${green}9.  ${cyan}清理签名服务器日志${background}
echo -e  ${green}10.  ${cyan}查看签名服务器链接${background}
echo -e  ${green}11.  ${cyan}打开签名服务器帮助${background}
echo -e  ${green}0.  ${cyan}退出${background}
echo "========================="
echo -e ${green}您的签名服务器状态: ${condition}${background}
echo -e ${green}当前签名服务器版本: ${Version}${background}
echo -e ${green}QQ群:${cyan}狐狸窝:705226976${background}
echo "========================="
echo
echo -en ${green}请输入您的选项: ${background};read number
case ${number} in
1)
echo
install_QSignServer
;;
2)
echo
start_QSignServer
;;
3)
echo
stop_QSignServer
;;
4)
echo
restart_QSignServer
;;
5)
echo
update_QSignServer
;;
6)
echo
uninstall_QSignServer
;;
7)
echo
key_QSignServer
;;
8)
port_QSignServer
;;
9)
echo
pm2 flush qsign
;;
10)
echo
link_QSignServer
;;
11)
echo
help_QSignServer
;;
test)
test_QSignServer
;;
0)
exit
;;
*)
echo
echo -e ${red}输入错误${background}
exit
;;
esac
}
if [ "${install_QSignServer}" == "true" ]
then
install_QSignServer
else
function mainbak()
{
   while true
   do
       main
       mainbak
   done
}
mainbak
fi