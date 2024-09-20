# mongodb 环境搭建

## windows

安装好 mongodb。

```bat
> mkdir db
> mongod --dbpath db
```

默认 dbpath 是 \data\db，对应到实际目录可能是 d:\data\db

mongod --help，看看有哪些参数。

### javascript shell

```
$ mongo
> use my_database
> db.users.insert({name: "kasicass})
> db.users.find()
{ "_id" : ObjectId("5a796e1abf516120b6807456"), "name" : "kasicass" }
```

如上，和 MySQL 不同，mongo 不需要 create database。

## Debian 9.5

参考 [Debian 9.5 Crash Course][1]

## FreeBSD 11

参见 [FreeBSD 11 Crash Course][2]

## OpenBSD 6.4

参考 [OpenBSD 6.4 Crash Course][3]

## 常用工具

* mongodump/mongorestore，备份/回复数据，用BSON格式。
* mongoexport/mongoimport，导入/导出 JSON/CSV/TSV
* mongosniff，查看 application 发送了啥信息给 mongod，调试用
* mongostat，类似iostat
* mongotop，类似top
* mongoperf，看看mongod 对disk的行为
* mongooplog，oplog
* bsondump，BSON => human-readable formats

[1]:https://github.com/kasicass/blog/blob/master/debian/2018_10_29_debian9_crash_course.md
[2]:https://github.com/kasicass/blog/blob/master/freebsd/2018_10_29_freebsd11_crash_course.md
[3]:https://github.com/kasicass/blog/blob/master/openbsd/2018_10_31_openbsd_6.3_crash_course.md
