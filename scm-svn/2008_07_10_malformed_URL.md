# [SVN] 编码问题引来的 Malformed URL

今天在服务器上给项目设置了一个 svn:externals，然后跑到 win32 下发现 co 不出来了，提示：Malformed URL ...

经同事指点，原来是编码问题，比如：

```
svn propedit svn:externals script
cehua  .../开发文档/cehua
```

这样的关联，虽然在服务器没问题，但 win32 下中文编码就不通了。因此要改为：

```
cehua  ../%e5%bc%80%e5%8f%91%e6%96%87%e6%a1%a3/cehua
```

经过 encode 之后，所有地方都通用啦。

ps. 编码问题还真是麻烦。。。。

### 如何 encode？

 * 方法一：放到 ie/chrome 的地址栏
 * 方法二：python, import urllib, urllib.quote("中文")
