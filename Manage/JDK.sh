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
if [ "$(uname -o)" = "Android" ]; then
	echo "大聪明出现了"
	exit 1
fi
JDK_URL="https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jdk/aarch64/linux/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.9_9.tar.gz"
if [ $(command -v apt) ];then
    apt update -y
    apt install -y tar gzip wget curl unzip git tmux pv
fi
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
if [[ ! "${JAVA_VERSION}" == "17.*"* ]]; then
    until wget -O jdk.tar.gz -c ${JDK_URL}
    do
      echo -e ${red}下载失败 ${green}正在重试${background}
    done
    echo -e ${yellow}正在解压JDK文件,请耐心等候${background}
    mkdir jdk
    pv jdk.tar.gz | tar -zxf - -C jdk
    mv jdk/$(ls jdk) /usr/local/JDK-17 
    rm -rf jdk.tar.gz > /dev/null 2>&1
    rm -rf jdk > /dev/null 2>&1
    if ! grep -q JDK /etc/profile;then
    echo 'PATH=$PATH:/usr/local/JDK_17/bin
export JAVA_HOME=/usr/local/JDK_17' >> /etc/profile
    source /etc/profile
    fi
    PATH=$PATH:/usr/local/JDK_17/bin
    export JAVA_HOME=/usr/local/JDK_17
fi
