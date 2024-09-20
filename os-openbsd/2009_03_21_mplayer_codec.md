# [OpenBSD] 配置 mplayer codec

从 ports 中安装 mplayer，自然，默认是不支持 rmvb 等东东的，需要下载对应的解码器。

下载最新的解码器，解压到 /usr/local/lib/win32

 * [http://www.mplayerhq.hu/design7/dload.html][1]
 * 目前最新：[http://www.mplayerhq.hu/MPlayer/releases/codecs/windows-essential-20071007.zip][2]

OB安全检查比较高，所以要设置些东西

```
sysctl machdep.userldt=1
```

然后就可以播放 rmvb 啦。

[1]:http://www.mplayerhq.hu/design7/dload.html
[2]:http://www.mplayerhq.hu/MPlayer/releases/codecs/windows-essential-20071007.zip
