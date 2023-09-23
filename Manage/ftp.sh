安装FTP服务器的步骤在不同的Linux发行版上略有不同，下面是在Ubuntu、CentOS、ArchLinux和Alpine上安装FTP服务器的基本步骤：

在Ubuntu上安装FTP服务器：
1. 打开终端，运行以下命令更新软件包列表：
   ```
   sudo apt update
   ```
2. 安装vsftpd（一个常用的FTP服务器）：
   ```
   sudo apt install vsftpd
   ```
3. 安装完成后，启动vsftpd服务：
   ```
   sudo systemctl start vsftpd
   ```
4. 如果需要在系统启动时自动启动vsftpd服务，可以运行以下命令：
   ```
   sudo systemctl enable vsftpd
   ```
5. 确保防火墙允许FTP流量通过：
   ```
   sudo ufw allow 20/tcp
   sudo ufw allow 21/tcp
   ```

在CentOS上安装FTP服务器：
1. 打开终端，以root用户身份运行以下命令安装vsftpd：
   ```
   yum install vsftpd
   ```
2. 安装完成后，启动vsftpd服务：
   ```
   systemctl start vsftpd
   ```
3. 如果需要在系统启动时自动启动vsftpd服务，可以运行以下命令：
   ```
   systemctl enable vsftpd
   ```
4. 确保防火墙允许FTP流量通过：
   ```
   firewall-cmd --permanent --add-port=20/tcp
   firewall-cmd --permanent --add-port=21/tcp
   firewall-cmd --reload
   ```

在ArchLinux上安装FTP服务器（以vsftpd为例）：
1. 打开终端，以root用户身份运行以下命令安装vsftpd：
   ```
   pacman -S vsftpd
   ```
2. 安装完成后，编辑`/etc/vsftpd.conf`文件进行配置：
   ```
   nano /etc/vsftpd.conf
   ```
   建议按需修改配置项，特别是`anonymous_enable`、`local_enable`和`write_enable`。
3. 启动vsftpd服务：
   ```
   systemctl start vsftpd
   ```
4. 如果需要在系统启动时自动启动vsftpd服务，可以运行以下命令：
   ```
   systemctl enable vsftpd
   ```
5. 确保防火墙允许FTP流量通过（如果启用了防火墙）：
   ```
   ufw allow 20/tcp
   ufw allow 21/tcp
   ```

在Alpine上安装FTP服务器（以vsftpd为例）：
1. 打开终端，以root用户身份运行以下命令安装vsftpd：
   ```
   apk add vsftpd
   ```
2. 安装完成后，编辑`/etc/vsftpd/vsftpd.conf`文件进行配置：
   ```
   vi /etc/vsftpd/vsftpd.conf
   ```
   建议按需修改配置项，特别是`anonymous_enable`、`local_enable`和`write_enable`。
3. 启动vsftpd服务：
   ```
   rc-service vsftpd start
   ```
4. 如果需要在系统启动时自动启动vsftpd服务，可以运行以下命令：
   ```
   rc-update add vsftpd
   ```

以上是在不同Linux发行版上安装FTP服务器的基本步骤。根据具体需求，你可能还需要进行进一步的配置和安全性设置。