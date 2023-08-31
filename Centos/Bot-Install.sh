cd $HOME
export red="\033[31m"
export green="\033[32m"
export yellow="\033[33m"
export blue="\033[34m"
export purple="\033[35m"
export cyan="\033[36m"
export white="\033[37m"
export background="\033[0m"

if [ $(command -v dnf) ];then
    pkg_install="dnf install -y"
elif [ $(command -v yum) ];then
    pkg_install="yum install -y"
fi
if [ ! -x "$(command -v xz)" ]
then
    echo -e ${yellow}安装软件 xz${background}
    ${pkg_install} xz
fi

if [ ! -x "$(command -v chromium)" ]
then
    echo -e ${yellow}安装软件 chromium${background}
    ${pkg_install} chromium
fi

Nodsjs_Version=$(node -v | cut -d '.' -f1)
if ! [[ "$Nodsjs_Version" == "v16" || "$Nodsjs_Version" == "v18" ]];the
    curl -o node.tar.xz https://cdn.npmmirror.com/binaries/node/latest-v18.x/node-v18.17.0-linux-${framework}.tar.xz
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


