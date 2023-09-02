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
if ! [[ "$Nodsjs_Version" == "v16" || "$Nodsjs_Version" == "v18" ]];then
    source <(curl -sL https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/BOT-ARCH.sh)
    wget -q --show-progress -O node.tar.xz -c https://cdn.npmmirror.com/binaries/node/latest-v18.x/node-v18.17.0-linux-${ARCH}.tar.xz
    bash 
fi
