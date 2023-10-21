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
echo -e ${red}签名服务器因为特殊原因 停止支持${background}
if [ ! "${install_QSignServer}" == "true" ]
then
    exit
fi