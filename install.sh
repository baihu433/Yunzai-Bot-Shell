#!/bin/env bash
if grep -q -E Alpine /etc/issue && [ -x /sbin/apk ];then

elif grep -q -E Arch /etc/issue && [ -x /usr/bin/pacman ];then

elif grep -q -E Kernel /etc/issue && [ -x /usr/bin/dnf ];then

elif grep -q -E Kernel /etc/issue && [ -x /usr/bin/yum ];then

elif grep -q -E Ubuntu /etc/issue && [ -x /usr/bin/apt ];then

elif grep -q -E Debian /etc/issue && [ -x /usr/bin/apt ];then

elif [ -x /usr/bin/zypper ];then

fi


