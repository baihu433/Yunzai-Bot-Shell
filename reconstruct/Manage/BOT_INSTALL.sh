#!/bin/env bash
Alpine_Script="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Alpine/Bot-Install.sh"
Arch_Script="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Arch/Bot-Install.sh"
Kernel_Script="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Centos/Bot-Install.sh"
Ubuntu_Script="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Ubuntu/Bot-Install.sh"
Debian_Script="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Debian/Bot-Install.sh"
Kali_Script="https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Kali/Bot-Install.sh"
if grep -q -E -i Alpine /etc/issue && [ -x /sbin/apk ];then
    bash <(curl -sL ${Alpine_Script})
elif grep -q -E -i Arch /etc/issue && [ -x /usr/bin/pacman ];then
    bash <(curl -sL ${Arch_Script})
elif grep -q -E -i Kernel /etc/issue && [ -x /usr/bin/dnf ];then
    bash <(curl -sL ${Kernel_Script})
elif grep -q -E -i Kernel /etc/issue && [ -x /usr/bin/yum ];then
    bash <(curl -sL ${Kernel_Script})
elif grep -q -E -i Ubuntu /etc/issue && [ -x /usr/bin/apt ];then
    bash <(curl -sL ${Ubuntu_Script})
elif grep -q -E -i Debian /etc/issue && [ -x /usr/bin/apt ];then
    bash <(curl -sL ${Debian_Script})
elif grep -q -E -i Kali /etc/issue && [ -x /usr/bin/apt ];then
    bash <(curl -sL ${Kali_Script})
elif grep -q -E -i Alpine /etc/os-release && [ -x /sbin/apk ];then
    bash <(curl -sL ${Alpine_Script})
elif grep -q -E -i Arch /etc/os-release && [ -x /usr/bin/pacman ];then
    bash <(curl -sL ${Arch_Script})
elif grep -q -E -i CentOS /etc/os-release && [ -x /usr/bin/dnf ];then
    bash <(curl -sL ${Kernel_Script})
elif grep -q -E -i CentOS /etc/os-release && [ -x /usr/bin/yum ];then
    bash <(curl -sL ${Kernel_Script})
elif grep -q -E -i Ubuntu /etc/os-release && [ -x /usr/bin/apt ];then
    bash <(curl -sL ${Ubuntu_Script})
elif grep -q -E -i Debian /etc/os-release && [ -x /usr/bin/apt ];then
    bash <(curl -sL ${Debian_Script})
elif grep -q -E -i Kali /etc/os-release && [ -x /usr/bin/apt ];then
    bash <(curl -sL ${Kali_Script})
fi