[SVN] 原来 svnserve 比 apache mod_dav_svn 快很多

apache mod_dav_svn 居然比 svnserve 慢很多。- -!

 * [http://stackoverflow.com/questions/502585/svnserve-vs-mod-dav-svn][1]

SVN作者的benchmark，貌似bdb比fsfs快一点。svnserve的svn up比mod_dav_svn快很多；不过svn co速度差不多。

 * [http://www.ohrner.net/download/sonstiges/krimskrams/svn_bench.csv][2]


自己架svn服务的话，选用 svnserve 吧，呵呵。

用项目的代码库测试了下，性能差距果然很明显。- -!

svnserve, 完整的代码库, svn co trunk

```
real    3m2.988s
user    0m19.794s
sys     0m24.805s
```

apache mod_dav_svn, 完整代码库，svn co trunk

```
real    12m45.787s
user    0m24.381s
sys     0m26.128s
```

[1]:http://stackoverflow.com/questions/502585/svnserve-vs-mod-dav-svn
[2]:http://www.ohrner.net/download/sonstiges/krimskrams/svn_bench.csv
