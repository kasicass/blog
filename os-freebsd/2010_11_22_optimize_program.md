# [FreeBSD] 服务器程序的优化

让玩家感觉反应快，就是主逻辑不要卡。一般分为2种：cpu和io。

## 卡cpu

一般卡的时候，top看到cpu占用100%，说明计算太多了，cpu不行了。

解法，看能不能把一些独立的逻辑线程化。

工具，我常用 gprof 看哪个函数是热点。对于脚本，自己写 profiler。

```
$ gcc -Wall -pg foo.c
$ ./a.out
$ gprof a.out a.out.gmon > outfile
```

## 卡io

卡的时候，top看到cpu占用很少，STATE为这几个状态 flswai, biord, biowr, genblk，基本都是卡io了。

对于api具体反应为 stat(), read(), write() 等函数 block 了一些时间才返回。

我碰到的一种情况是，进程A fork 出进程 B，进程B 负责把数据写盘（数据量很大），而进程A 也在此时少量写盘，就会如此，0.5 ~ 1 sec的延迟，对于玩家来说都是不可接受的。

工具，ktrace 是好东西，请看 manpage。

```
$ ktrace -p 52858
$ ktrace -C
$ kdump -E -H -f ktrace.out > outfile
```

* -E, Display elapsed timestamps (time since beginning of trace)
这个参数比较有用，用于查看某个 syscall 是不是卡了很久。
* -H 显示线程tid
* 8.0 之后还有高级货 dtrace。还有个 truss，不好用。

通过 $ systat -iostat 看当时的io流量。

内核 syscall 入口，/src/sys/kern/init_sysent.c  从这里开始寻找对应的 api。

如果进程卡在某个逻辑上，希望知道程序现在在做啥，可以通过如下方法打印traceback，相当coool：

* [http://blog.yufeng.info/archives/873][1]

[1]:http://blog.yufeng.info/archives/873
