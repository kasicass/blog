# [SVN] ra_serf: The server sent a truncated HTTP response body
[http://tigris-scm.10930.n7.nabble.com/ra-serf-The-server-sent-a-truncated-HTTP-response-body-td95848.html][1]

The data sent is too big and the server closes the connection due to 
reaching a limit. 

Possible steps which can help fix this issue: 

* Increase the timeout value on the server 
* set compression level to zero on the server (will make everything slower but helps with this issue) 
* make sure all proxies that are in between you and the svn server also have the timeout values increased 

-----------------------------------

美术SVN仓库过大（150G左右），第一次 checkout 的时候，经常会碰到。

不停地 svn cleanup & svn update，直到全部内容 checkout 成功为止。

[1]:http://tigris-scm.10930.n7.nabble.com/ra-serf-The-server-sent-a-truncated-HTTP-response-body-td95848.html
