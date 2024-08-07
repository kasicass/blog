# FreeBSD 11.2 Crash Course

## 安装系统

下载 FreeBSD-11.2-RELEASE-amd64-disc1.iso，一路安装即可。

* [https://mirrors.ustc.edu.cn/freebsd/releases/ISO-IMAGES/14.1/][1]

## 基本设置

### about su

默认，user 都不能 su。修改 /etc/group，将自己的 user 加入 wheel 组。

### about ssh

默认 ssh 设置为不允许 remote login with password。参考 [这里][2]

```
# vi /etc/sshd/sshd_config
PasswordAuthentication yes

# /etc/rc.d/sshd restart
```

## 软件安装

设置 package mirror

```
# mkdir -p /usr/local/etc/pkg/repos
# vi /usr/local/etc/pkg/repos/FreeBSD.conf
FreeBSD: {
  url: "pkg+http://mirrors.ustc.edu.cn/freebsd-pkg/${ABI}/quarterly",
}
```

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
