# [pthread] 线程的属性(2) -- sched policy & priority (REALTIME)

线程的另一块属性，包括调度算法(schedule policy)和优先级(priority)。pthread 中数字越大，优先级越高。

调度算法在 sched.h 中定义，包括 SCHED_RR, SCHED_FIFO, SCHED_OTHER。其中 SCHED_RR, SCHED_FIFO 用于定义实时操作系统(real-time os)的线程模型，而 SCHED_OTHER 则为 implementation-specific。

* SCHED_RR - round robin, 每个线程有自己的 time-slice，slice 用完，就自动切换到同优先级的另一个线程上执行。
* SCHED_FIFO - 类似 RR，但没有 time-slice 概念，只有当线程 A 退出，才允许同优先级的其他线程开始执行。如此这般，从高优先级到低优先级。
* SCHED_OTHER - 一般目前的系统 linux, freebsd 对其的实现都是"简单的抢占式，没有优先级的概念。

注意：

* 因为 priority 是与 policy 相关的东西，所以要先设置 policy，再设置 priority。
* 另，policy 会影响 mutex, rwlock 等等同步机制的唤醒顺序。

当然，上面是几种调度算法比较标准的行为。**线程的具体行为，还是要看你操作系统的内部实现。**

比如我在 FreeBSD 6.2 下测试，-lpthread (libkse) 和 -lthr (libthr) 的行为，都是不一样的。-lpthread 考虑了优先级的影响，而 -lthr 则直接忽略之。而 policy 对调度的影响都不大。

对于已经运行中的线程，可以通过 pthread_getprio / setprio 来设置 priority。

想要体验真正的 real-time thread，估计只能去玩玩 Embeded OS 了，比如：RTLinux。

```C
#include <unistd.h>
#include <sched.h>      // for SCHED_FIFO/OTHER/RR, struct sched_param
#include <pthread.h>
#include <stdio.h>

struct {
    pthread_t pid;
    int prio;
} pids[] = {
    { NULL, 1, },
    { NULL, 1, },
    { NULL, 2, },
    { NULL, 2, },
    { NULL, 3, },
    { NULL, 3, },
};

#define NELEMS(x)       (sizeof(x) / sizeof(x[0]))

void *mythr(void *arg)
{
    int n = (int) arg;
    int i = 0;
    printf("thr #%d enter\n", n);
    sleep(1);  // wait for all threads started

    while ( i < 99999999*5 )   // 让每个线程运行一段时间，然后 print 一句
    {
        i++;
        if ( i % 99999999 == 0 ) printf("thr #%d running %d\n", n, i);
    }

    return (void *)0;
}

int main()
{
    int i;
    struct sched_param sp;
    pthread_attr_t attr;

    pthread_attr_init(&attr);

    pthread_attr_setschedpolicy(&attr, SCHED_FIFO);
    for ( i = 0; i < NELEMS(pids); i++ )
    {
        sp.sched_priority = pids[i].prio;
        pthread_attr_setschedparam(&attr, &sp);
        pthread_create(&pids[i].pid, &attr, mythr, (void *)i);
    }

    for ( i = 0; i < NELEMS(pids); i++ )
        pthread_join(pids[i].pid, NULL);

    pthread_attr_destroy(&attr);
    return 0;
}
```

```
$ ./a.out             # -lthr
thr #1 enter
thr #5 enter
thr #4 enter
thr #3 enter
thr #2 enter
thr #0 enter
thr #1 running 99999999
thr #5 running 99999999
thr #4 running 99999999
thr #2 running 99999999
thr #3 running 99999999
thr #0 running 99999999
.....
```

```
$ ./a.out           # -lpthread
thr #5 enter
thr #4 enter
thr #2 enter
thr #3 enter
thr #0 enter
thr #1 enter
thr #5 running 99999999
thr #4 running 99999999
thr #4 running 199999998
thr #5 running 199999998
thr #4 running 299999997
thr #5 running 299999997
thr #4 running 399999996
thr #5 running 399999996
thr #4 running 499999995
thr #5 running 499999995
thr #2 running 99999999
thr #3 running 99999999
thr #2 running 199999998
thr #3 running 199999998
thr #2 running 299999997
.....
```
