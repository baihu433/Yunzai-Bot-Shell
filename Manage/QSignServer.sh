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
if [ -d $HOME/QSignServer/JRE ];then
    export PATH=$PATH:$HOME/QSignServer/JRE/bin
    export JAVA_HOME=$HOME/QSignServer/JRE
fi
QSIGN_URL="https://gitee.com/baihu433/Yunzai-Bot-Shell/releases/download/QSignServer/unidbg-fetch-qsign-1.1.9.zip"
NewVersion="1.0.2"
QSIGN_VERSION="119"
qsign_version="1.1.9"
txlib="https://gitee.com/baihu433/txlib"
function tmux_new(){
Tmux_Name="$1"
Shell_Command="$2"
if ! tmux new -s ${Tmux_Name} -d "${Shell_Command}"
then
    echo -e ${yellow}QSignServer启动错误"\n"错误原因:${red}${tmux_new_error}${background}
    echo
    echo -en ${yellow}回车返回${background};read
    main
    exit
fi
}
function tmux_attach(){
Tmux_Name="$1"
tmux attach -t ${Tmux_Name} > /dev/null 2>&1
}
function tmux_kill_session(){
Tmux_Name="$1"
tmux kill-session -t ${Tmux_Name}
}
function tmux_ls(){
Tmux_Name="$1"
tmux_windows=$(tmux ls 2>&1)
if echo ${tmux_windows} | grep -q ${Tmux_Name}
then
    return 0
else
    return 1
fi
}
function qsign_curl(){
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    port_=$(grep -E port ${file} | awk '{print $2}' | sed 's/"//g' | sed "s/://g" )
done
if curl -sL 127.0.0.1:${port_} > /dev/null 2>&1
then
    return 0
else
    return 1
fi
}
function tmux_gauge(){
i=0
Tmux_Name="$1"
tmux_ls ${Tmux_Name} & > /dev/null 2>&1
until qsign_curl
do
    i=$((${i}+1))
    a="${a}#"
    echo -ne "\r${i}% ${a}\r"
    if [[ ${i} == 40 ]];then
        echo
        return 1
    fi
done
echo
}
bot_tmux_attach_log(){
Tmux_Name="$1"
if ! tmux attach -t ${Tmux_Name} > /dev/null 2>&1
then
    tmux_windows_attach_error=$(tmux attach -t ${Tmux_Name} 2>&1 > /dev/null)
    echo
    echo -e ${yellow}QSignServer打开错误"\n"错误原因:${red}${tmux_windows_attach_error}${background}
    echo
    echo -en ${yellow}回车返回${background};read
fi
}
case $(uname -m) in
amd64|x86_64)
JRE_URL="https://mirrors.tuna.tsinghua.edu.cn/Adoptium/21/jre/x64/linux/OpenJDK21U-jre_x64_linux_hotspot_21.0.2_13.tar.gz"
;;
arm64|aarch64)
JRE_URL="https://mirrors.tuna.tsinghua.edu.cn/Adoptium/21/jre/aarch64/linux/OpenJDK21U-jre_aarch64_linux_hotspot_21.0.2_13.tar.gz"
;;
esac
if [ $(command -v apk) ];then
case $(uname -m) in
    amd64|x86_64)
        JRE_URL="https://mirrors.tuna.tsinghua.edu.cn/Adoptium/21/jre/x64/alpine-linux/OpenJDK21U-jre_x64_alpine-linux_hotspot_21.0.2_13.tar.gz"
    ;;
    arm64|aarch64)
        JRE_URL="https://mirrors.tuna.tsinghua.edu.cn/Adoptium/21/jre/aarch64/alpine-linux/OpenJDK21U-jre_aarch64_alpine-linux_hotspot_21.0.2_13.tar.gz"
    ;;
esac
fi
function install_QSignServer(){
if [ -d $HOME/QSignServer/txlib ];then
    echo -e ${yellow}您已安装签名服务器${background}
    exit
fi
if [ -e /etc/resolv.conf ]; then
    if ! grep -q "114.114.114.114" /etc/resolv.conf && grep -q "8.8.8.8" /etc/resolv.conf ;then
        cp -f /etc/resolv.conf /etc/resolv.conf.backup
        echo -e ${yellow}DNS已备份至 /etc/resolv.conf.backup${background}
        echo "nameserver 114.114.114.114" > /etc/resolv.conf
        echo "nameserver 8.8.8.8" >> /etc/resolv.conf
        echo -e ${yellow}DNS已修改为 114.114.114.114 8.8.8.8${background}
    fi
fi
if [ $(command -v apt) ];then
    apt update -y
    apt install -y tar gzip wget curl unzip git tmux pv
elif [ $(command -v yum) ];then
    yum update -y
    yum install -y tar gzip wget curl unzip git tmux pv
elif [ $(command -v dnf) ];then
    dnf install -y tar gzip wget curl unzip git tmux pv
elif [ $(command -v pacman) ];then
    pacman -Syy --noconfirm --needed tar gzip wget curl unzip git tmux pv
elif [ $(command -v apk) ];then
    apk update
    apk add --no-cache tar gzip wget curl unzip git tmux pv
else
    echo -e ${red}不受支持的Linux发行版${background}
    exit
fi
git clone --depth=1 https://gitee.com/baihu433/QSignServer
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
if [[ ! "${JAVA_VERSION}" == "2.1*"* ]]; then
    rm -rf $HOME/QSignServer/JRE > /dev/null 2>&1
    rm -rf $HOME/jre.tar.gz > /dev/null 2>&1
    until wget -O jre.tar.gz -c ${JRE_URL}
    do
      echo -e ${red}下载失败 ${green}正在重试${background}
    done
    if [ ! -d $HOME/QSignServer ];then
        mkdir QSignServer
    fi
    echo -e ${yellow}正在解压JRE文件,请耐心等候${background}
    mkdir JRE
    pv jre.tar.gz | tar -zxf - -C JRE
    mv JRE/$(ls JRE) QSignServer/JRE
    rm -rf jre.tar.gz
    rm -rf JRE
    PATH=$PATH:$HOME/QSignServer/JRE/bin
    export JAVA_HOME=$HOME/QSignServer/JRE
fi
echo "${NewVersion}" > $HOME/QSignServer/Version
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
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    port_="$(grep -E port ${file} | awk '{print $2}' | sed 's/"//g' | sed s/://g )"
done
if curl 127.0.0.1:${port_} > /dev/null 2>&1
then
    echo -en ${yellow}签名服务器已启动 ${cyan}回车返回${background};read
    echo
    return
fi
echo -e ${white}"====="${green}白狐-QSignServer${white}"====="${background}
echo -e ${cyan}请选择签名服务器适配的QQ共享库版本${background}
echo -e  ${green} 1.  ${cyan}HD: 8.9.58${background}
echo -e  ${green} 2.  ${cyan}HD: 8.9.63${background}
echo -e  ${green} 3.  ${cyan}HD: 8.9.68${background}
echo -e  ${green} 4.  ${cyan}HD: 8.9.70${background}
echo -e  ${green} 5.  ${cyan}HD: 8.9.71${background}
echo -e  ${green} 6.  ${cyan}HD: 8.9.73${background}
echo -e  ${green} 7.  ${cyan}HD: 8.9.75${background}
echo -e  ${green} 8.  ${cyan}HD: 8.9.76${background}
echo -e  ${green} 9.  ${cyan}HD: 8.9.78${background}
echo -e  ${green}10.  ${cyan}HD: 8.9.80${background}
echo -e  ${green}11.  ${cyan}HD: 8.9.83${background}
echo -e  ${green}12.  ${cyan}HD: 8.9.85${background}
echo -e  ${green}13.  ${cyan}HD: 8.9.88${background}
echo -e  ${green}14.  ${cyan}HD: 8.9.90${background}
echo -e  ${green}15.  ${cyan}HD: 8.9.93${background}
echo -e  ${green}16.  ${cyan}HD: 8.9.96${background}
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
7|8.9.75)
export version=8.9.75
;;
8|8.9.76)
export version=8.9.76
;;
9|8.9.78)
export version=8.9.78
;;
10|8.9.80)
export version=8.9.80
;;
11|8.9.83)
export version=8.9.83
;;
12|8.9.85)
export version=8.9.85
;;
13|8.9.88)
export version=8.9.88
;;
14|8.9.90)
export version=8.9.90
;;
15|8.9.93)
export version=8.9.93
;;
16|8.9.96)
export version=8.9.96
;;
*)
echo
echo -e ${red}输入错误${background}
exit
;;
esac
if [ ! -d $HOME/QSignServer/txlib/${version} ];then
    echo -e ${yellow}您没有该版本的libfekit.so文件${background}
    exit
fi
Foreground_Start(){
bash $HOME/QSignServer/qsign${QSIGN_VERSION}/bin/unidbg-fetch-qsign --basePath=$HOME/QSignServer/txlib/${version}
echo -en ${cyan}回车返回${background}
read
echo
}
Tmux_Start(){
Start_Stop_Restart="启动"
tmux_new qsignserver "until bash $HOME/QSignServer/qsign${QSIGN_VERSION}/bin/unidbg-fetch-qsign --basePath=$HOME/QSignServer/txlib/${version};do;echo -e ${red}程序停止 正在重启${background};done"
if tmux_gauge qsignserver
then
    echo
    echo -en ${green}${Start_Stop_Restart}成功 是否打开窗口 [Y/N]:${background}
    read YN
    case ${YN} in
    Y|y)
        bot_tmux_attach_log qsignserver
    ;;
    *)
        echo -en ${cyan}回车返回${background}
        read
        echo
    ;;
    esac
fi
}
Pm2_Start(){
if [ -x "$(command -v pm2)" ]
then
    if ! pm2 show qsignserver | grep -q online > /dev/null 2>&1
    then
        pm2 start --name qsignserver "bash $HOME/QSignServer/qsign${QSIGN_VERSION}/bin/unidbg-fetch-qsign --basePath=$HOME/QSignServer/txlib/${version}"
        echo
        echo -en ${yellow}签名服务器已经启动,是否打开日志 [Y/n]${background};read num
        case $num in
        Y|y)
            pm2 logs qsignserver
            echo
            ;;
        esac
    fi
else
    echo -e ${red}没有pm2!!!${background}
    exit
fi
}
echo
echo -e ${white}"====="${green}白狐-QSignServer${white}"====="${background}
echo -e ${cyan}请选择启动方式${background}
echo -e  ${green}1.  ${cyan}前台启动${background}
echo -e  ${green}2.  ${cyan}TMUX后台启动${background}
echo -e  ${green}3.  ${cyan}PM2后台启动${background}
echo "========================="
echo -en ${green}请输入您的选项: ${background};read num
case ${num} in 
1)
Foreground_Start
;;
2)
Tmux_Start
;;
3)
Pm2_Start
;;
*)
echo
echo -e ${red}输入错误${background}
exit
;;
esac
}

function main(){
function stop_QSignServer(){
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    port_=$(grep -E port ${file} | awk '{print $2}' | sed 's/"//g' | sed "s/://g" )
done
if curl 127.0.0.1:${port_} > /dev/null 2>&1
then
    echo -e ${yellow}正在停止签名服务器${background}
    tmux_kill_session qsignserver > /dev/null 2>&1
    pm2 delete qsignserver > /dev/null 2>&1
    PID=$(ps aux | grep qsign | sed '/grep/d' | awk '{print $2}')
    if [ ! -z ${PID} ];then
        kill -9 ${PID}
    fi
    echo -en ${red}签名服务器停止成功 ${cyan}回车返回${background}
    read
    echo
    return
else
    echo -en ${red}签名服务器未启动 ${cyan}回车返回${background}
    read
    echo
    return
fi
}

function restart_QSignServer(){
if tmux_ls qsignserver > /dev/null 2>&1 
then
    tmux_kill_session qsignserver
    export Start_Stop_Restart="重启"
    start_QSignServer
elif pm2 show qsignserver | grep -q online > /dev/null 2>&1
then
    pm2 delete qsignserver
    start_QSignServer
else
    echo -e ${red}签名服务器未启动或为后台运行${background}
    echo
    return
fi
}

function update_QSignServer(){
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    port_=$(grep -E port ${file} | awk '{print $2}' | sed 's/"//g' | sed "s/://g" )
done
if curl 127.0.0.1:${port_} > /dev/null 2>&1
then
    echo -e ${yellow}正在停止签名服务器${background}
    tmux_kill_session qsignserver > /dev/null 2>&1
    pm2 delete qsignserver > /dev/null 2>&1
    PID=$(ps aux | grep qsign | sed '/grep/d' | awk '{print $2}')
    if [ ! -z ${PID} ];then
        kill -9 ${PID}
    fi
    echo
fi
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    port_=$(grep -E port ${file} | awk '{print $2}' | sed 's/"//g' | sed "s/://g" )
done
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    key_=$(grep -E key ${file} | awk '{print $2}' | sed 's/"//g' | sed "s/,//g" )
done
git clone --depth=1 https://gitee.com/baihu433/QSignServer
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
if [[ ! "${JAVA_VERSION}" == "2.1*"* ]]; then
    rm -rf $HOME/QSignServer/JRE > /dev/null 2>&1
    rm -rf $HOME/jre.tar.gz > /dev/null 2>&1
    until wget -O jre.tar.gz -c ${JRE_URL}
    do
      echo -e ${red}下载失败 ${green}正在重试${background}
    done
    if [ ! -d $HOME/QSignServer ];then
        mkdir QSignServer
    fi
    echo -e ${yellow}正在解压JRE文件,请耐心等候${background}
    mkdir JRE
    pv jre.tar.gz | tar -zxf - -C JRE
    mv JRE/$(ls JRE) QSignServer/JRE
    rm -rf jre.tar.gz
    rm -rf JRE
    PATH=$PATH:$HOME/QSignServer/JRE/bin
    export JAVA_HOME=$HOME/QSignServer/JRE
fi
echo "${NewVersion}" > $HOME/QSignServer/Version
export Version=${NewVersion}
echo "${NewVersion}" > $HOME/QSignServer/Version
}

function uninstall_QSignServer(){
if [ ! -d $HOME/QSignServer/qsign* ];then
    echo -en ${red}您还没有部署签名服务器!!! ${cyan}回车返回${background};read
    return
fi
cd $HOME
echo -e ${yellow}正在停止服务器运行${background}
tmux_kill_session qsignserver > /dev/null 2>&1
pm2 delete qsignserver > /dev/null 2>&1
rm -rf $HOME/QSignServer > /dev/null 2>&1
rm -rf $HOME/QSignServer > /dev/null 2>&1
Version="${red}[未部署]"
}

function log_QSignServer(){
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    port_=$(grep -E port ${file} | awk '{print $2}' | sed 's/"//g' | sed "s/://g" )
done
if ! curl 127.0.0.1:${port_} > /dev/null 2>&1
then
    echo -en ${red}签名服务器 未启动 ${cyan}回车返回${background};read
    echo
    return
fi
if tmux_ls qsignserver > /dev/null 2>&1 
then
    bot_tmux_attach_log qsignserver
elif pm2 show qsignserver | grep -q online > /dev/null 2>&1
then
    pm2 logs qsignserver
fi
}

function key_QSignServer(){
if [ ! -d $HOME/QSignServer/qsign* ];then
    echo -en ${red}您还没有部署签名服务器!!! ${cyan}回车返回${background};read
    return
fi
echo -en ${green}请输入更改后的key: ${background};read key_
if [ -z "${key_}" ]; then
    echo -en ${red}输入错误 回车返回${background};read
    return
fi
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    key=$(grep -E key ${file} | awk '{print $2}' | sed 's/"//g' | sed "s/,//g" )
    sed -i "s/${key}/${key_}/g" ${file}
done
echo -en ${yellow}更改完成 回车返回${background};read
}

function port_QSignServer(){
if [ ! -d $HOME/QSignServer/qsign* ];then
    echo -en ${red}您还没有部署签名服务器!!! ${cyan}回车返回${background};read
    return
fi
echo -en ${green}请输入更改后的端口号: ${background};read port_
if [ -z "${port_}" ]; then
    echo -en ${red}输入错误 回车返回${background};read
    return
fi
for folder in $(ls -d $HOME/QSignServer/txlib/*)
do
    file="${folder}/config.json"
    port=$(grep -E port ${file} | awk '{print $2}' | sed 's/"//g' | sed "s/://g" )
    sed -i "s/${port}/${port_}/g" ${file}
done
echo -en ${yellow}更改完成 回车返回${background};read
}

function link_QSignServer(){
if [ ! -d $HOME/QSignServer/qsign* ];then
    echo -en ${red}您还没有部署签名服务器!!! ${cyan}回车返回${background};read
    return
fi
echo -e ${green}您的各版本API链接${background}
echo
for folder in $(ls $HOME/QSignServer/txlib)
do
    file="$HOME/QSignServer/txlib/${folder}/config.json"
    port=$(grep -E port ${file} | awk '{print $2}' | sed 's/"//g' | sed "s/://g" )
    key=$(grep -E key ${file} | awk '{print $2}' | sed 's/"//g' | sed "s/,//g" )
    host=$(grep -E host ${file} | awk '{print $2}' | sed 's/"//g' | sed "s/,//g" )
    echo -e ${green}${folder}: ${cyan}"http://""${host}":"${port}"/sign?key="${key}"${background}
    echo
done
echo -en ${yellow}回车返回${background};read
}

if [[ -d $HOME/QSignServer ]];then
    for folder in $(ls -d $HOME/QSignServer/txlib/*)
    do
        file="${folder}/config.json"
        port_=$(grep -E port ${file} | awk '{print $2}' | sed 's/"//g' | sed "s/://g" )
    done
    if curl -sL 127.0.0.1:${port_} > /dev/null 2>&1
    then
        QsignVersion=$(curl -sL 127.0.0.1:${port_} | grep version | sed 's|"||g' | sed 's|:||g' | sed 's|,||g')
        QsignVersion=$(echo ${QsignVersion} | awk '{print $4}')
        condition="${cyan}[${QsignVersion}]"
    else
        condition="${red}[未启动]"
    fi
    if [ -e $HOME/QSignServer/Version ];then
        Version=$(cat $HOME/QSignServer/Version)
    fi
    if [ "${Version}" == "${NewVersion}" ]
    then
        Version="${cyan}[${Version}]"
    else
        Version="${red}${Version}[请更新]"
    fi
else
    Version="${red}[未部署]"
    condition="${red}[未部署]"
fi
echo -e ${white}"====="${green}白狐-QSignServer${white}"====="${background}
echo -e  ${green} 1.  ${cyan}安装签名服务器${background}
echo -e  ${green} 2.  ${cyan}启动签名服务器${background}
echo -e  ${green} 3.  ${cyan}关闭签名服务器${background}
echo -e  ${green} 4.  ${cyan}重启签名服务器${background}
echo -e  ${green} 5.  ${cyan}更新签名服务器${background}
echo -e  ${green} 6.  ${cyan}卸载签名服务器${background}
echo -e  ${green} 7.  ${cyan}打开签名服务器窗口/日志${background}
echo -e  ${green} 8.  ${cyan}修改签名服务器key值${background}
echo -e  ${green} 9.  ${cyan}修改签名服务器端口${background}
echo -e  ${green}10.  ${cyan}查看签名服务器链接${background}
echo -e  ${green}0.   ${cyan}退出${background}
echo "========================="
echo -e ${green}签名服务器脚本版本: ${Version}${background}
echo -e ${green}签名服务器适配版本: ${condition}${background}
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
log_QSignServer
;;
8)
echo
key_QSignServer
;;
9)
port_QSignServer
;;
10)
echo
link_QSignServer
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
elif [ "${start_QSignServer}" == "true" ]
then
    start_QSignServer
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


