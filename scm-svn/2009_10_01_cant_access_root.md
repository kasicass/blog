# [SVN] "未授权打开根进行编辑操作"的bug

参考：[http://chin.bokee.com/6226742.html][1]

今天也碰到这个问题了，还好有google。汗！

-------------------------------

环境:

 * Linux + svnserv
 * Eclipse + Subclipse

故障:

更新的时候报"未授权打开根进行编辑操作"错误,无路哪层目录均报错

authz文件内容如下:

```
[groups]
dev = chin

[/]
@dev = rw
```

权宜之计:

```
@dev = rw

换成

* = r
```

任何人都可以读，但这样就失去了安全性。

更好的解决办法（做梦也没想到是这个参数的原因，-_-可以视为bug）

conf/svnserv.conf文件中设置这个参数:

```
anon = none
```

默认的是

```
anon = read
```


[1]:http://chin.bokee.com/6226742.html
