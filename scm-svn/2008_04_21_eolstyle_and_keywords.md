# [SVN] svn:eol-style / svn:keywords

## svn:eol-style

一个项目，同时需要在 windows, unix 下 checkout 代码，会用到不同的编辑器编辑代码。

windows 下的编辑器，很多会将 eol(end-of-line) 自动转换为 CRLF，然后一提交代码，svn 提示每一行都有修改。

为了解决此问题，svn 专门提供了一个 svn:eol-style 这个 property。只要将 svn:eol-style 设置为 native，每次 checkout，svn 会自动将 eol 转换为当前系统的默认格式。

### example

给 repos 中所有 *.c 文件添加 svn:eol-style 属性。

```
svn propset svn:eol-style native -R *.c
svn ci -m "add svn:eol-style for all files"
```

对于发布一个项目，比如 windows 平台上，可以通过下面的方法，来保证所有文件 eol 的统一：

```
svn export file://tmp/repos my-export --native-eol CRLF
```


## svn:keywords

阅读开源项目的代码时，我们时常会看到类似下面的修改记录。这是如何做到的呢？

```C
// $Id: foo.c 24 2008-04-21 05:51:59Z kasicass $
```

只需要对特定的文件设置 svn:keywords 属性，然后在文件中写上

```C
// $Id:$
```

则每次 checkout 此文件，svn 都会更新此记录，显示文件最近修改的情况（修改时间、修改人）。

### example

设置 svn:keywords 属性

```
svn propset svn:keywords Id foo.c
```

设置多个 svn:keywords 属性

```
svn propset svn:keywords "Id HeadURL" bar.c
```

## 参考资料

property 的详细内容，参阅 svn manual [Chapter 7. Advanced Topics] -> [Properties] -> [Special Properties]。

