# [OpenBSD] DRI support

OB一直不支持DRI，不过从4.4开始，things are changing

* [http://dri.freedesktop.org/][1]
 
按文章所说，4.4开始，内核就已经有DRI的支持了，只是默认不打开。

* [http://undeadly.org/cgi?action=article&sid=20081029164221][2]
  
开启步骤：

```
1) boot -c
2) enable {inteldrm,radeondrm} (whichever you need to use)
3) quit
4) let it finish booting and startx
5) if it works, you may make this permanent using config -ef /bsd
```

进入 startx 后，验证是否起效，glxinfo | grep renderer，看看是否为 direct rendering
 
不过我的 4.4 按上面的步骤，doesn't work :-(。4.5 已经默认开启 DRI，等出来后就升级，呵呵。

[1]:http://dri.freedesktop.org/
[2]:http://undeadly.org/cgi?action=article&sid=20081029164221
