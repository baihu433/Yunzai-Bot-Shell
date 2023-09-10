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

pkg_list=("node-gyp" "nodejs" "nodejs-nopt" "npm" "pnpm" "semver")
for package in ${pkg_list[@]}
do
    if pacman -Qs "${package}" > /dev/null 2>&1;then
        echo -e ${yellow}安装软件 ${package}${background}
        pacman -R --noconfirm ${package}
    fi
done

pkg_list=("tar" "pv" "xz" "gzip" "wget" )
for package in ${pkg_list[@]}
do
    if ! pacman -Qs "${package}" > /dev/null 2>&1;then
        echo -e ${yellow}安装软件 ${package}${background}
        pacman -Syy --noconfirm --needed ${package}
    fi
done

if [ -x "$(command -v node)" ]
then
    Nodsjs_Version=$(node -v | cut -d '.' -f1)
fi

if ! [[ "$Nodsjs_Version" == "v16" || "$Nodsjs_Version" == "v18" ]];then
    echo -e ${yellow}安装软件 Node.JS${background}
    source <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Manage/BOT-ARCH.sh)
    until wget -q --show-progress -O node.tar.xz -c https://cdn.npmmirror.com/binaries/node/latest-v18.x/node-v18.17.0-linux-${ARCH}.tar.xz
    do
        if [ ${i} -eq 3 ]
        then
            echo -e ${red}错误次数过多 退出${background}
            exit
        fi
        i=$((${i}+1))
        echo -e ${red}安装失败 3秒后重试${background}
        sleep 3s
    done
fi

if [ ! -d node ];then
    mkdir node
fi
echo -e ${yellow}正在解压二进制文件压缩包${background}
pv node.tar.xz | tar -xJf - -C node
rm -rf /usr/local/node > /dev/null
rm -rf /usr/local/node > /dev/null
mv -f node/$(ls node) /usr/local/node
if [ ! -d $HOME/.local/share/pnpm ];then
    mkdir -p $HOME/.local/share/pnpm
fi
export PATH=$PATH:/usr/local/node/bin
export PATH=$PATH:/root/.local/share/pnpm
export PNPM_HOME=/root/.local/share/pnpm
if ! grep -q '#Node.JS' /etc/profile;then
echo '
#Node.JS
export PATH=$PATH:/usr/local/node/bin
export PATH=$PATH:/root/.local/share/pnpm
export PNPM_HOME=/root/.local/share/pnpm
' >> /etc/profile
fi
if [ -e /etc/fish/config.fish ];then
if ! grep -q '#Node.JS' /etc/fish/config.fish;then
echo '
#Node.JS
set -x PATH /root/.local/share/pnpm /usr/local/node/bin $PATH
set PNPM_HOME /root/.local/share/pnpm
' >> /etc/fish/config.fish
fi
source /etc/fish/config.fish
fi
source /etc/profile
rm -rf node node.tar.xz > /dev/null
rm -rf node node.tar.xz > /dev/null
if [ ! -x "$(command -v pnpm)" ];then
    echo -e ${yellow}正在使用npm安装pnpm${background}
    a=0
    npm config set registry https://registry.npmmirror.com
    npm config set registry https://registry.npmmirror.com
    npm install -g npm@latest
    until npm install -g pnpm@latest
    do
      if [ "${a}" == "3" ];then
        echo -e ${red}错误次数过多 退出${background}
        exit
      fi
      echo -e ${red}pnpm安装失败 ${green}正在重试${background}
      a=$(($a+1))
    done
    echo
fi
echo -e ${yellow}正在为pnpm更换默认源${background}
pnpm config set registry https://registry.npmmirror.com
pnpm config set registry https://registry.npmmirror.com
pnpm config set node_sqlite3_binary_host_mirror https://npmmirror.com/mirrors/sqlite3
pnpm config set node_sqlite3_binary_host_mirror https://npmmirror.com/mirrors/sqlite3