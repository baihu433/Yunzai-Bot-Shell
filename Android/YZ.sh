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

sed -i "s/bash YZ.sh//g" $HOME/.bashrc
rm YZ.sh > /dev/null
sed -i 's/ports.ubuntu.com/mirrors.bfsu.edu.cn/g' /etc/apt/sources.list
apt update -y
apt install eatmydata -y
eatmydata apt install -y whiptail
eatmydata apt install -y fonts-wqy* language-pack-zh* locales-all redis redis-server git curl wget tar gzip xz-utils
echo 'export LANG="zh_CN.UTF-8"' >> /etc/profile
export LANG="zh_CN.UTF-8"
bash <(curl https://gitee.com/baihu433/chromium/raw/master/chromium.sh)
echo -e ${yellow}正在安装ffmpeg${background}
bash <(curl https://gitee.com/baihu433/ffmpeg/raw/master/ffmpeg.sh)
case $(uname -m) in
x86_64|amd64)
node=x64
;;
arm64|aarch64|armv8*)
node=arm64
;;
armhf|armel|armv7*)
node=armv7l
;;
*)
echo ${red}您的框架为${yellow}$(uname -m)${red},快让白狐做适配.${background}
exit
esac
bash <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/install.sh)