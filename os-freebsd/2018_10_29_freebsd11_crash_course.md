# FreeBSD 11.2 Crash Course

## 安装系统

下载 FreeBSD-14.1-RELEASE-amd64-disc1.iso，一路安装即可。

* [https://mirrors.ustc.edu.cn/freebsd/releases/ISO-IMAGES/14.1/][1]

## 基本设置

### about su

默认，user 都不能 su。修改 /etc/group，将自己的 user 加入 wheel 组。

```
# pw groupmod wheel -m kasicass

# cat /etc/group | head
wheel:*:0:root,kasicass
...
```

### about ssh

默认 ssh 设置为不允许 remote login with password。参考 [这里][2]

```
# vi /etc/ssh/sshd_config
PasswordAuthentication yes

# /etc/rc.d/sshd restart
```

## 软件安装

FreeBSD pkg 包管理器的官方源配置是 /etc/pkg/FreeBSD.conf ，请先检查该文件内容。注意其中的 url 参数配置了官方仓库的地址，我们需要把它替换为镜像站的地址。

该配置文件是 FreeBSD 基本系统的一部分，会随着 freebsd-update 更新，请不要直接修改，而是创建 /usr/local/etc/pkg/repos/FreeBSD.conf 覆盖配置，文件内容如下：

```
FreeBSD: {
  url: "pkg+http://mirrors.ustc.edu.cn/freebsd-pkg/${ABI}/quarterly",
}
```
如果要使用滚动更新的 latest 仓库，把 url 配置最后的 quarterly 换成 latest 即可。

修改配置后，运行 pkg update -f 更新索引。

感谢 [中科大][3]


```
查找软件
pkg search <package>

查看详细信息
pkg info <package>

安装/卸载
pkg install <package>
pkg delete <package>

升级所有软件
pkg upgrade
```

## 常用软件

```
# pkg install vim-console-8.1.0342
# pkg install git-2.19.1
# pkg install pypy-6.0.0_1
# pkg install tmux-2.7
# pkg install go-1.11,1
```

git 基本配置

```
$ git config --global user.name "your_name"
$ git config --global user.email "your_email"
```

## vim & tmux 的基本配置

```
$ cat ~/.shrc
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
```

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

[1]:https://download.freebsd.org/ftp/releases/ISO-IMAGES/11.2/
[2]:https://envotechie.com/2010/10/28/password-login-ss-freebsd/
[3]:http://mirrors.ustc.edu.cn/help/freebsd-pkg.html
