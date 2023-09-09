#!/bin/env bash
Alpine_Script=

if grep -q -E -i Alpine /etc/issue && [ -x /sbin/apk ];then
    bash <(curl -sL Script)
elif grep -q -E -i Arch /etc/issue && [ -x /usr/bin/pacman ];then
    bash <(curl -sL Script)
elif grep -q -E -i Kernel /etc/issue && [ -x /usr/bin/dnf ];then
    bash <(curl -sL Script)
elif grep -q -E -i Kernel /etc/issue && [ -x /usr/bin/yum ];then
    bash <(curl -sL Script)
elif grep -q -E -i Ubuntu /etc/issue && [ -x /usr/bin/apt ];then
    bash <(curl -sL Script)
elif grep -q -E -i Debian /etc/issue && [ -x /usr/bin/apt ];then
    bash <(curl -sL Script)
elif grep -q -E -i manjaro /etc/issue && [ -x /usr/bin/pacman ];then
    bash <(curl -sL Script)
elif grep -q -E -i Kali /etc/issue && [ -x /usr/bin/apt ];then
    bash <(curl -sL Script)
elif grep -q -E -i Alpine /etc/os-release && [ -x /sbin/apk ];then
    bash <(curl -sL Script)
elif grep -q -E -i Arch /etc/os-release && [ -x /usr/bin/pacman ];then
    bash <(curl -sL Script)
elif grep -q -E -i CentOS /etc/os-release && [ -x /usr/bin/dnf ];then
    bash <(curl -sL Script)
elif grep -q -E -i CentOS /etc/os-release && [ -x /usr/bin/yum ];then
    bash <(curl -sL Script)
elif grep -q -E -i OpenSUSE /etc/os-release && [ -x /usr/bin/zypper ];then
    bash <(curl -sL Script)
elif grep -q -E -i Ubuntu /etc/os-release && [ -x /usr/bin/apt ];then
    bash <(curl -sL Script)
elif grep -q -E -i Debian /etc/os-release && [ -x /usr/bin/apt ];then
    bash <(curl -sL Script)
elif grep -q -E -i Kali /etc/os-release && [ -x /usr/bin/apt ];then
    bash <(curl -sL Script)
fi