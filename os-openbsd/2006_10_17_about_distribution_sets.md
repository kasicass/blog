# 小肥鱼上的 Distribution Sets

Distribution Sets 就是操作系统的组件，我们可以有选择性地安装这些组件，以构建我们所需要的系统。OpenBSD的 set 不多，就那么几个，下面是这些 set 的含义：

```
bsd                 The kernel (required) 
bsd.mp              The multi-processor kernel (only on some platforms) 
bsd.rd              The ramdisk kernel 
baseXX.tgz          The base system (required) 
compXX.tgz          The compiler collection, headers and libraries 
manXX.tgz           Manual pages 
gameXX.tgz          Text-based games 
xbaseXX.tgz         Base libraries and utilities for X11 (requires xshareXX.tgz) 
xfontXX.tgz         Fonts used by X11 
xservXX.tgz         X11's X servers 
xshareXX.tgz        X11's man pages, locale settings and includes 
```

Some libraries from xbaseXX.tgz, like freetype or fontconfig, can be used outside of X by programs that manipulate text or graphics. Such programs will usually need fonts, either from xfontXX.tgz or font packages. For the sake of simplicity, the developers decided against maintaining a minimal xbaseXX.tgz set that would allow most non-X ports to run. The xservXX.tgz set is rarely needed if you don't intend to run X. 

简单说

 * 用 X window，去掉 game，其它全装
 * 不用 X window，去掉 game, xserv, xshare，其它全装
