# WebDAV 快速指南 

## 需求

在不同的机器之间共享数据。之前没用过 WebDAV，试了下，真方便！


## WebDAV Server

在 Linux 服务器上架设 WebDAV Server。

```shell
$ pip3 install wsgidav
$ pip3 install cheroot

$ wsgidav --host=0.0.0.0 --port=10086 --root=/home/kasicass/webdav_root --auth=anonymous
```


## Windows Client

挂接网盘

```shell
D:\>net use w: http://47.121.137.193:10086/
命令成功完成。
```

删除网盘

```shell
D:\>net use w: /DELETE
w: 已经删除。
```


## Mac Client

参考：[WebDAV – 安全分享檔案的另一種選擇][1]


## 参考资料

* [WebDAV Specifications][2]


[1]:https://www.asustor.com/zh-tw/online/College_topic?topic=208
[2]:http://www.webdav.org/specs/
