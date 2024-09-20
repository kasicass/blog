# [pthread] 线程属性(4) -- detach state

貌似漏介绍了最常用的一个属性，detach state。如果是 joinable thread，我们**必须**在一个线程中通过 pthread_join(pid) 等待另一线程 pid 退出，否则 pid 将永远不能被系统回收。

而如果是 detached thread，则**不能** pthread_join，线程退出后自动被系统回收。

对于运行中的 joinable thread，可以通过 pthread_detach() 将其变成 detached thread，**反之不然**。

```C
#include <unistd.h>
#include <pthread.h>
#include <stdio.h>

void *mythr(void *arg)
{
    if ( (int)arg != 3 ) sleep((int)arg);
    printf("thr = %d\n", (int)arg);
    return (void *)0;
}

int main()
{
    pthread_t pid;
    pthread_attr_t attr;

    pthread_attr_init(&attr);

    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
    pthread_create(&pid, &attr, mythr, (void*)1);   // #1 = detached thread

    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
    pthread_create(&pid, &attr, mythr, (void*)2);   // #2 = joinable thread
    pthread_detach(pid);    // joinable ==> detached

    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
    pthread_create(&pid, &attr, mythr, (void*)3);   // #3 = joinable thread
    sleep(5);  // 让 #3 thr 先退出，然后下面再等待其的退出信号 (join it)
    pthread_join(pid, NULL);

    pthread_attr_destroy(&attr);

    return 0;
}
```
