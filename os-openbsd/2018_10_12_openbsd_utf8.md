# OpenBSD UTF8


## 解决办法

```shell
# 加入 ~/.profile
export LC_CTYPE=en_US.UTF-8
```

然后 vim 就可以编辑 utf8 了。如果 vim 还是乱码，说明没有正确继承 LC_CTYPE，需要如下：

```shell
# .vimrc
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8
```


## 背景

OpenBSD 选择只支持 C/POSIX 和 UTF-8 两种编码。
