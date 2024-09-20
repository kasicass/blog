# [OpenBSD] 改变你隶属的group

今天碰到一个问题，需要将一个账户从 GrpA 转移到 GrpB，虽然知道 chpass 可以改用户的基本设置，但一直没弄出来。问了一下僵尸，终于搞定了，哇咔咔。

其实很简单，在 root 权限下：
```
chpass username
```

即可手动修改用户 username 的基本数据。里面的 gid 是数字，可以在 /etc/group 找到需要的 group。

OpenBSD 中， man chpass 里面提到了一个 YP enviroment 不知道是虾米东西，不懂~~
