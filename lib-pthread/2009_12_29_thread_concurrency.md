# [pthread] thread concurrency

我们可以通过 pthread_getconcurrency / setconcurrency 来设置进程的"并发度"。我没有细究这个"并发度"用于啥情况，从 FreeBSD 代码看来，应该是 M:N thread model (libpthread, libkse) 的遗产，1:1 thread model (libthr) 中这两个函数不起任何作用。

这有篇资料，我自己没细究。

* [http://readlist.com/lists/netbsd.org/current-users/1/8461.html][1]

[1]:http://readlist.com/lists/netbsd.org/current-users/1/8461.html
