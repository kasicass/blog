# [OpenBSD] compile vim cscope-support

很早的一篇文章，发现没有贴到 blog 上，呵呵，贴一下，并作一些补充。

===================================================

今天在自己的 OpenBSD 上编译 vim7，如下： 

```
cd /usr/ports/editors/vim/ 
env FLAVOR="no_x11" make install 
```

本来一切OK的，但讨厌的是，no_x11 版本的 vim 居然没有 cscope feature ... 这可不行，还得靠 cscope 读代码咧。小小研究了一翻，下面是自己使用的 ugly 的方法。

```
env FLAVOR="no_x11" make fetch 
env FLAVOR="no_x11" make checksum 
env FLAVOR="no_x11" make depends 
env FLAVOR="no_x11" make extract 
env FLAVOR="no_x11" make patch 
env FLAVOR="no_x11" make configure 

// ok, 这里先停下来，用 vi 修改 vim source 中的 feature.h 
// 强行定义 #define FEAT_CSCOPE，然后继续我们的安装 

env FLAVOR="no_x11" make build 
env FLAVOR="no_x11" make fake 
env FLAVOR="no_x11" make package 
env FLAVOR="no_x11" make install 
```

嘿嘿，如此这般周折，总算把带 cscope feature 的 vim 装起来了。上面步骤中 fetch -> install 的流程，其实 是 BSD ports tree 的整个安装步骤，我其实就是打断这个流程，自己做了写配置。fetch, patch, .... 等的具体含义，参见 man ports。

```
# vim --version | grep cscope 
+cryptv +cscope +cursorshape -dnd ... // 开起来没什么问题 
```

我这里使用的方法，其实是非常暴力的，主要是自己对 BSD 还不熟悉。本来 vim 安装的时候只需要 

```
./configure --enable-cscope 
```

就好了的，但 ports 包装了所有的东西，自己还没弄清楚。 

装好 vim，再去将 cscope 装上，vim + cscope 是很好的 code reading tool。(vim 必须编译了 
cscope feature 才能和 cscope 工具共同使用) 

参见 [http://cscope.sourceforge.net/cscope_vim_tutorial.html][1]

===================================================

其实不需要如上这么麻烦，直接修改 /usr/ports/editors/vim/ 上的 Makefile：

```
FLAVORS=    huge gtk2 athena motif no_x11 perl python ruby
FLAVOR?=    gtk2

CONFIGURE_STYLE=gnu
CONFIGURE_ENV=  CPPFLAGS="-I${DEPBASE}/include" LDFLAGS="-L${DEPBASE}/lib"
CONFIGURE_ARGS+=--with-tlib="curses" --enable-multibyte --enable-cscope
```

然后编译即可。不过对于 configure 能有哪些参数，只能自己看 source code 里面的 configure 啦。

===================================================

如果此时已经安装了 vim，需要重新编译 cscope-support，则

```
pkg_delete vim
rm /usr/ports/packages/i386/vim-*
...
```

然后把上面 configure => install 的流程跑一遍即可。

[1]:http://cscope.sourceforge.net/cscope_vim_tutorial.html
