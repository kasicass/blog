# [SVN] Could not read status line: connection was closed by server

今天碰到此问题。svn relocate 没试验过，估计有效。

TortoiseSVN

1. 先 Clear Auth Data
2. 将项目 SVN 下随意一个子目录，找一个别的位置 Checkout 出来，输入账号/密码那，不要永久保存账号密码。
3. 回到项目 SVN 的目录，Update。输入账号/密码后，解决。

参考

* [http://stackoverflow.com/questions/613149/svn-could-not-read-status-line-connection-was-closed-by-server][1]

 [1]:http://stackoverflow.com/questions/613149/svn-could-not-read-status-line-connection-was-closed-by-server
