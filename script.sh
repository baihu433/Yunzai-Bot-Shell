echo '# The termux repository mirror from TUNA:
deb https://mirrors.bfsu.edu.cn/termux/apt/termux-main stable main' > $PREFIX/etc/apt/sources.list
apt update -y && apt upgrade -y
apt install -y openssh
#whoami
#8082