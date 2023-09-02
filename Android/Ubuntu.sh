#!/data/data/com.termux/files/usr/bin/bash
cd $HOME
if ! [ "$(uname -o)" = "Android" ]; then
	echo "看来你是大聪明 加Q群获取帮助吧 596660282"
	exit
fi
if [ -d "../usr/var/lib/proot-distro/installed-rootfs/ubuntu/root/" ];then
echo
echo -e "\033[32m检测到您已经安装ubuntu\033[0m"
echo -e "\033[32m请使用这条命令启动\033[0m"
echo -e "\033[33mproot-distro login ubuntu\033[0m"
exit 0
fi
echo -e '\033[36m请允许存储与后台权\033[0m'
echo y | termux-setup-storage
sleep 2s
termux-wake-lock
sleep 2s
echo 'deb https://mirrors.bfsu.edu.cn/termux/termux-packages-24 stable main' > $PREFIX/etc/apt/sources.list
yes Y | pkg update -y && pkg upgrade -y
echo 'deb https://mirrors.bfsu.edu.cn/termux/termux-packages-24 stable main' > $PREFIX/etc/apt/sources.list
pkg update -y
pkg install git wget proot-distro -y
echo "proot-distro login ubuntu" > $PREFIX/bin/U
chmod +x $PREFIX/bin/U
if ! [ -d "../usr/var/lib/proot-distro/dlcache" ];then
mkdir -p ../usr/var/lib/proot-distro/dlcache
fi
case $(uname -m) in
  arm64|aarch64)
    ubuntu=aarch64
    ;;
  amd64|x86_64)
    ubuntu=x86_64
    ;;
  arm|armhf|armel)
    ubuntu=arm
    ;;
  *)
    echo -e "\033[31m暂不支持您的设备\033[0m"
    exit
    ;;
esac
until wget -O ubuntu-${ubuntu}-pd-v3.10.0.tar.xz -c https://ghproxy.com/https://github.com/termux/proot-distro/releases/download/v3.10.0/ubuntu-${ubuntu}-pd-v3.10.0.tar.xz
do
echo -e "\033[31m下载失败 重试中\033[0m"
done
mv -f ubuntu-${ubuntu}-pd-v3.10.0.tar.xz ../usr/var/lib/proot-distro/dlcache
proot-distro install ubuntu
wget -O YZ.sh https://gitee.com/baihu433/Yunzai-Bot-Shell/raw/master/Android/YZ.sh
mv YZ.sh ../usr/var/lib/proot-distro/installed-rootfs/ubuntu/root/
echo > ../usr/var/lib/proot-distro/installed-rootfs/ubuntu/usr/bin/locale-check
echo > ../usr/var/lib/proot-distro/installed-rootfs/ubuntu/root/.hushlogin
chmod +x ../usr/var/lib/proot-distro/installed-rootfs/ubuntu/usr/bin/locale-check
echo "bash YZ.sh" >> ../usr/var/lib/proot-distro/installed-rootfs/ubuntu/root/.bashrc
ln -s ../usr/var/lib/proot-distro/installed-rootfs/ubuntu/root/ $HOME/root
echo "proot-distro login ubuntu" > .bashrc
proot-distro login ubuntu