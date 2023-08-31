cd $HOME
export red="\033[31m"
export green="\033[32m"
export yellow="\033[33m"
export blue="\033[34m"
export purple="\033[35m"
export cyan="\033[36m"
export white="\033[37m"
export background="\033[0m"

case $(uname -m) in
x86_64|amd64)
framework=x64
;;
arm64|aarch64)
framework=arm64
;;
*)
echo ${red}您的框架为${yellow}$(uname -m)${red},快让白狐做适配.${background}
exit
;;
esac

function pkg_install(){
i=0
until apk add ${pkg}
do
    if [ ${i} -eq 3 ]
    then
        echo -e ${red}错误次数过多 退出${background}
        exit
    fi
    i=$((${i}+1))
    echo -en ${red}命令执行失败 ${green}3秒后重试${background}
    sleep 3s
    echo
done
}

pkg_list=("tar" "xz" "gzip" "pv" "redis" "redis-server" "wget" "curl" "unzip" "git" "dpkg")
for pkg in ${pkg_list[@]}
do
    if [ ! -x "$(command -v ${pkg})" ]
    then
        echo -e ${yellow}安装软件${cyan}${pkg}${background}
        pkg_install
    fi
done


