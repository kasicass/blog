# [SVN] Access to '/svn/repo/!svn/me' forbidden

TorsiseSVN 上看到 '/svn/!svn/me' forbidden 还以为是本地 svn 目录内容有损坏呢。

后来发现是服务器没设置权限 =_=! 。这提示。。。

**解决方案：**检查权限设置。

参考

* [https://stackoverflow.com/questions/15786130/access-to-svn-ctm-svn-me-forbidden-when-commit-to-svn-server/43204615#43204615][1]
* [http://svnbook.red-bean.com/en/1.7/svn.serverconfig.pathbasedauthz.html][2]


[1]:https://stackoverflow.com/questions/15786130/access-to-svn-ctm-svn-me-forbidden-when-commit-to-svn-server/43204615#43204615
[2]:http://svnbook.red-bean.com/en/1.7/svn.serverconfig.pathbasedauthz.html

