# [pthread] 线程的属性(3) -- scope & inherit sched (REALTIME)

thread 的属性中，还有 scope 和 inherit sched 没讲解。再接再厉，本文把剩下的内容补完。

pthread_attr_getscope, pthread_attr_setscope 用于设置线程的 scope 是 PTHREAD_SCOPE_SYSTEM 还是 PTHREAD_SCOPE_PROCESS。

PTHREAD_SCOPE_SYSTEM，指 1:1 thread model，此属性的线程与其他内核线程一样，共同分享 cpu 的时间片。

而 PTHREAD_SCOPE_PROCESS，来源于 M:N thread model，多个有此属性的用户态线程对应一个内核线程，与其他内核线程分享 cpu 时间片。

 * [http://www.net.t-labs.tu-berlin.de/~gregor/tools/pthread-scheduling.html][1]

但，在最新的各大 *nix 系统中(FreeBSD 8.0, NetBSD, SunOS)，大家分分放弃复杂的 M:N model。所以 PTHREAD_SCOPE_PROCESS 参数也就不再其啥作用了。

 * [http://en.wikipedia.org/wiki/Thread_%28computer_science%29][2]

对于 inherit sched 也很简单，pthread_attr_getinheritsched / pthread_attr_setinheritsched 设置此属性：

 * PTHREAD_INHERIT_SCHED, 线程A创建线程B，B 继承 A 的 scope, policy, priority
 * PTHREAD_EXPLICIT_SCHED, 线程A创建线程B，B 使用 pthread_create 指定的 scope, policy, priority

[1]:http://www.net.t-labs.tu-berlin.de/~gregor/tools/pthread-scheduling.html
[2]:http://en.wikipedia.org/wiki/Thread_%28computer_science%29

