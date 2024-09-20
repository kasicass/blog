# build libunwind

install autoconf & automake

```
# pkg_add -v autoconf-2.69
# pkg_add -v automake-1.16
# pkg_add -v libtool

$ cat ~/.profile
export AUTOCONF_VERSION=2.69
export AUTOCONF_VERSION=1.16
```

```
$ wget url-to-libunwind.tar.gz
$ tar zxf libunwind.tar.gz
$ cd libunwind
$ ./autogen.sh
$ ./configure
$ make
```

