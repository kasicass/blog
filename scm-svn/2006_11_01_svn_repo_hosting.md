# [SVN] 自己创建 svn 仓库

用了一段时间的 svn client，今天老大让自己把自己写的代码也管理起来。鉴于测试服务器不稳定，说不定哪天就把我原来的东西 delete 掉了，所以在自己机器上建立 SVN 的仓库。

在 Win32 下使用 cygwin，仓库目录：/home/svn/repos

### 创建仓库

```
svnadmin create /home/svn/repos
```

### 修改 config file

修改 /home/svn/repos/conf 下的两个文件，主要是打开注释掉的一些选项

svnserve.conf

```
[general]

anon-access = read
auth-access = write

password-db = passwd

# authz-db = authz

realm = Kasicass' SVN Repository
```

passwd

```
[users]
kasicass = your_password
```

### 启动 svnserve

```
svnserve -d -r /home/svn/repos
```

为了方便，可以写一个启动脚本，需要 SVN repos 的时候执行一下，即可。

之后，我们就可以用

```
svn co svn://ip address/
```

来访问我们的 SVN repos 了。


## 后记

很简单吧？呵呵~

原来打算在 OpenBSD 里面架设的，但 VMware port forwarding 又似乎有问题了，不成功，只能作罢。


## 2008-02-22 更新

svnserve 在 FreeBSD 下 daemon 默认绑定的是 tcp6，所以启动服务的写法应该是：

```
svnserve -d -r /path/to/repos --listen-host=192.168.1.15
```

其中，服务器的 ip = 192.168.1.15，具体请参考：

[http://svnbook.red-bean.com/en/1.4/svn.ref.svnserve.html][1]

[1]:http://svnbook.red-bean.com/en/1.4/svn.ref.svnserve.html
