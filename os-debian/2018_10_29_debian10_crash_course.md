# Debian 9.5 Crash Course


## 安装系统

下载 netinst.iso，一路安装即可。

* [http://mirrors.163.com/debian-cd/10.6.0/amd64/iso-cd/debian-10.6.0-amd64-netinst.iso][1]
* 版本升级后，上面的链接可能失效，去这下面找找：[http://mirrors.163.com/debian-cd/][9]
* 使用 netinst版 安装过程中，如果没有找到网络，参考 附录1。

源选择163，速度有保障。

* [http://mirrors.163.com/debian/][2]

在安装 package 那一步，只选择 SSH Server，其它的 package 都不选。


## 软件安装（使用aptitude）

package source，包的源，比如：[http://mirrors.163.com/debian/][2]

```
# cat /etc/apt/sources.list
deb http://mirrors.163.com/debian/ stretch main contrib non-free
deb-src http://mirrors.163.com/debian/ stretch main contrib non-free
```

```
apt-get, 是 APT 的第一版 command-line 工具
apt，是 APT 的第二版 command-line 工具
aptitude，是 graphical interface （也支持 command-line，我一般用这个）

aptitude update，从源上，拉取最新的package信息
aptitude full-update，更新所有安装的package到最新版本

aptitude search <keyword>，根据 keyword 寻找 package

aptitude install <package>，安装package
aptitude remove <package>，删除patcker
aptitude show <package>，显示packaged的详细信息

aptitude clean，删除本地下载的所有 .deb 文件
```


## 常用软件

```
# apt-get install aptitude
# aptitude install make gcc g++
# aptitude install net-tools sysstat locate ntpdate tmux
```

* aptitude
* net-tools: ifconfig, netstat
* sysstat: sar, iostat, mpstat
* locate: locate, updatedb
* ntpdate: ntpdate pool.ntp.org
* tmux: terminal multiplexer


## 开机&关机

* debian10 改用 systemd
* 'shutdown -h now' or 'reboot' 失效

```
# systemctl poweroff
# systemctl reboot
```


## Python & Pip

```
# aptitude install python-dev python-pip python3-dev python3-pip
# pip install cffi
# pip3 install cffi
```


## 启用 mongodb

```
# aptitude install mongodb
```

安装完后，mongodb 就启动了。常用的管理命令：

```
# systemctl start mongodb
# systemctl stop mongodb
# systemctl restart mongodb
```

[systemd][3] 是一套管理各种 service process 的管理器。配置文件放在 /etc 下面。

用 locate 寻找 systemd 配置文件。

```
# updatedb
# locate mongodb.service
/etc/systemd/system/multi-user.target.wants/mongodb.service
```

mongodb 配置文件

* /etc/mongodb.conf

启动 mongo 会看到

```
** WARNING: soft rlimits too low. rlimits set to 31861 processes, 65535 files.
Number of processes should be at least 32767.5 : 0.5 times number of files.
```

虽然开发环境无所谓，但看着烦躁，还是解决下。解决方法看 [这里][4]，修改 mongodb.service，增加如下内容：

```
[Service]
LimitFSIZE=infinity
LimitCPU=infinity
LimitAS=infinity
LimitMEMLOCK=infinity
LimitNOFILE=64000
LimitNPROC=64000
```

重启服务，搞定。

```
# systemctl daemon-reload
# systemctl restart mongodb
```


## 启用 mysql

```
# aptitude install mysql-server
```

mysql配置文件

* /etc/mysql/my.cnf

默认dbpath

* /var/lib/mysql

debian9开始，mysql使用系统的认证。让某个 user 可以通过 mysql client 访问 mysql-server，需要：
```
# su
# mysql

> USE mysql;
> CREATE USER 'YOUR_SYSTEM_USER'@'localhost' IDENTIFIED VIA unix_socket;
> exit;
```

* 参考，[https://wiki.debian.org/MySql][5]
* 重置密码，[https://www.vultr.com/docs/reset-mysql-root-password-on-debian-ubuntu][6]


## 启用 vsftpd

[handbook][7] 推荐使用 vsftpd。

```
# aptitude install vsftpd
```

安装之后，系统会自动新建名为 ftp 的 user。并且 vsftpd 已经启动。

默认 ftp root 在 /srv/ftp。

修改 /etc/vsftpd.conf，允许 anonymous 登陆/上传。

```
# vim /etc/vsftpd.conf
anonymous_enable=YES
local_enable=NO
write_enable=YES
anon_upload_enable=YES
anon_mkdir_write_enable=YES

# systemctl restart vsftpd

# echo "test" > /srv/ftp/test.txt
# chown ftp:ftp /srv/ftp/test.txt
```

此时，用 windows 的 ftp client，已经可以下载文件了。

注意，需要启用 binary 模式。ascii 模式的下载，默认关闭的（参考 vsftpd.conf）

```
> ftp ip_addr
... 用 anonymous 登陆

ftp> binary
ftp> get test.txt
```

但上传还是失败。

```
ftp> put somefile.txt
553 Could not create file.
```

如果之前没打开 anon_upload_enable=YES，会提示：

```
ftp> put somefile.txt
550 Permission denied.
```

本来以为是 [SELinux][8] 的设置问题，但 debian 默认安装，并没有开启 SELinux：

```
# id -Z
id: --context (-Z) works only on an SELinux-enabled kernel
```


## vim & tmux 的基本配置

```
$ cat ~/.vimrc
" basic
syn on
set tabstop=2
set nobackup
set background=dark
colorscheme desert
set number

$ cat ~/.tmux.conf
# hjkl pane traversal
bind h select-pan -L
bind j select-pan -D
bind k select-pan -U
bind l select-pan -R

# reload me
bind r source ~/.tmux.conf\; display "/.tmux.conf sourced!"
```


## 参考资料

 * 《[The Debian Administrator's Handbook - Debian 9][12]》


## 附录1 - 手工配置网络

安装过程中，没找到网络，无法 apt 安装各种 packages。万恶的是，ifconfig 这种工具，都不在 basic system 中。

* virtualbox 的 debian10 上，肯定安装了 net-tools
* 通过 U盘，将 nettools 的 .deb 复制到目标机器上
* /var/cache/apt/archives/net-tools_1.60+git20161116.90da8a0-1_amd64.deb

```
# mkdir /mnt/usb
# mount -t msdos /dev/sdb /mnt/usb
# dpkg -i /mnt/usb/net-tools_1.60+git20161116.90da8a0-1_amd64.deb
```

有了 ifconfig。

## 附录2 - USB Wifi Adapter

在京东买了个 [TP-Link 的 USB Wifi Adapter][10]。插入机器上，提示

```
firmware: failed to load mt7601u.bin
```

/etc/apt/sources.list 中配置好 non-free

```
deb http://mirrors.163.com/debian/ stretch main contrib non-free
deb-src http://mirrors.163.com/debian/ stretch main contrib non-free
```

安装 firmware-misc-nonfree。

```
# aptitude install firmware-misc-nonfree
```

重插一下 USB Wifi，然后看看是否 work 了：

```
$ lsusb -t

```

安装驱动。

[https://wiki.debian.org/WiFi][11]




[1]:http://mirrors.163.com/debian-cd/10.6.0/amd64/iso-cd/debian-10.6.0-amd64-netinst.iso
[2]:http://mirrors.163.com/debian/
[3]:http://www.freedesktop.org/wiki/Software/systemd/
[4]:https://docs.mongodb.com/manual/reference/ulimit/#linux-distributions-using-systemd
[5]:https://wiki.debian.org/MySql
[6]:https://www.vultr.com/docs/reset-mysql-root-password-on-debian-ubuntu
[7]:https://debian-handbook.info/browse/stable/sect.ftp-file-server.html
[8]:https://debian-handbook.info/browse/stable/sect.selinux.html
[9]:http://mirrors.163.com/debian-cd/
[10]:https://item.jd.com/618066.html
[11]:https://wiki.debian.org/WiFi
[12]:http://l.github.io/debian-handbook/html/en-US/

