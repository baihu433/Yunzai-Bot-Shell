#!/bin/env bash

if [ ! -x "$(command -v xz)" ]
then
    echo -e ${yellow}安装软件 xz${background}
    apt install -y xz-utils
fi

if ! dpkg -s chromium-browser >/dev/null 2>&1
        then
            until
            do
                bash <(curl -sL https://gitee.com/baihu433/chromium/raw/master/chromium.sh)
                sleep 3s
            done
fi

Nodsjs_Version=$(node -v | cut -d '.' -f1)
if ! [[ "$Nodsjs_Version" == "v16" || "$Nodsjs_Version" == "v18" ]];then
if awk '{print $2}' /etc/issue | grep -q -E 22.*
    then
        curl -o node.tar.xz https://cdn.npmmirror.com/binaries/node/latest-v18.x/node-v18.17.0-linux-${framework}.tar.xz
elif awk '{print $2}' /etc/issue | grep -q -E 23.*
    then
        curl -o node.tar.xz https://cdn.npmmirror.com/binaries/node/latest-v18.x/node-v18.17.0-linux-${framework}.tar.xz     
else
        curl -o node.tar.xz https://cdn.npmmirror.com/binaries/node/latest-v16.x/node-v16.20.0-linux-${framework}.tar.xz
fi
    if [ ! -d node ];then
    mkdir node
    fi
    echo -e ${yellow}正在解压二进制文件压缩包${background}
    pv node.tar.xz|tar -xJf - -C node
    rm -rf /usr/local/node > /dev/null
    rm -rf /usr/local/node > /dev/null
    mv -f node/$(ls node) /usr/local/node
    if [ ! -d $HOME/.local/share/pnpm ];then
        mkdir -p $HOME/.local/share/pnpm
    fi
    export PATH=$PATH:/usr/local/node/bin
    export PATH=$PATH:/root/.local/share/pnpm
    export PNPM_HOME=/root/.local/share/pnpm
    echo '
#Node.JS
export PATH=$PATH:/usr/local/node/bin
export PATH=$PATH:/root/.local/share/pnpm
export PNPM_HOME=/root/.local/share/pnpm
' >> /etc/profile
    source /etc/profile
    rm -rf node node.tar.xz > /dev/null
    rm -rf node node.tar.xz > /dev/null
fi

if [ ! -x "$(command -v pnpm)" ];then
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