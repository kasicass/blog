# 在OpenBSD中直接解.tar.bz2的小脚本

在OpenBSD中，没有tar jxf命令，.tar.bz2是不能直接解开的。但我们可以通过下面的命令：

```shell
bzip2 -d < compressed_file | tar xf -
```

不过上面的命令太繁琐了，下面是我在网上找到的一段小脚本，把其放到 /usr/local/bin/ 下，并 chmod +x bzipx，则以后只需下面命令便可解压 .tar.bz2 这样的东东：

```shell
bzipx compressed_file
```

```shell
#!/bin/ksh

# Written by geek00L[20060223] - The easy bzip2 decompression script for OpenBSD
# Revision
# 20050306 - Improved error message handling as well as bzip2 checking


if [ -f /usr/local/bin/bzip2 ]
then
    echo "bzip2 is installed" > /dev/null
else
    echo "bzip2 not found, please install it via ports/packages"
    exit 1
fi

Kompressed="$1"

if [ $# -ne 1 ]
then
    echo "Usage: $0 compressed_file"
    exit 1
fi

if [ -f $Kompressed ]
then
    /usr/local/bin/bzip2 -d < $Kompressed | tar xf -
fi
```
