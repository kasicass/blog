# [SVN] set property - do it automatically

我们希望项目中的所有文件，都带有如下属性

```
svn:eol-sytle = native
svn:keywords = Id
```

但每次 svn add 一个文件，property 并不会自动设置上。不过 svn 提供了 config file，可以方便地设置这些东东。

## Unix

修改这个文件中的配置 ~/.subversion/config 即可。

对于 *nix 还可以修改 /etc/subversion/config 给所有用户以统一的配置。对于在一台机器上做开发的服务端程序员倒是十分方便。当然，~/.subversion/config 中的设定，会覆盖 /etc/subversion/config 中的。

ps. 我自己使用的 subversion 1.4.0，统一配置文件的路径在 /usr/local/etc/subversion/config。而最新的 1.4.5 则改为 /etc/subversion/config。正确的位置，可以阅读你系统上的 ~/.subversion/README.txt。

## Windows

Windows 下大多使用 TortoiseSVN，直接在 [Setting] -> [General] -> Subversion configuration file [Edit] 修改即可。

## config example

自己项目中常用的 config 配置：

```
[miscellany]
enable-auto-props = yes

[auto-props]
*.c = svn:eol-style=native;svn:keywords=Id
*.cpp = svn:eol-style=native;svn:keywords=Id
*.h = svn:eol-style=native;svn:keywords=Id
Makefile = svn:eol-style=native;svn:keywords=Id
```

ps. 个人觉 auto-set property 这个特性设计为每个用户自己配置并不合理，一般一个项目，这类 property 都是统一的，如果设计为每个 repos 固定一种 auto-set perperty 就好。不过这又不满足"一个 repos 同时存放多个 project"的情况。
