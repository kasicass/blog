# [pthread] thread-specific data

想使用 thread-specific data，首先要通过 pthread_key_create() 拿到一个 key。之后每个线程都可以使用此 key，但每个线程各自设置自己的 specific data (pthread_setspecific / getspecific)，互不影响。

用 pthrad_key_delete() 释放此 key。key 的释放并不会调用 specific data destructor，destructor 会在线程退出时自动调用。

啥时候会用此种 thread-specific data 呢？

  1. 用来实现 errno
  2. 用来模拟 macos 上的 __thread (tls), 看 [这里][1]

```C
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

void mydtor(void *data)
{
    printf("dtor = %p\n", data);
    free(data);
}

void *mythr1(void *arg)
{
    char *data = malloc(10);
    pthread_key_t key = (pthread_key_t) arg;

    printf("thr #1 data1 = %p\n", data);
    pthread_setspecific(key, data);
    sleep(1);

    data = pthread_getspecific(key);
    printf("thr #1 data2 = %p\n", data);

    return (void *)0;
}

void *mythr2(void *arg)
{
    char *data = malloc(10);
    pthread_key_t key = (pthread_key_t) arg;

    sleep(1);
    printf("thr #2 data1 = %p\n", data);
    pthread_setspecific(key, data);

    data = pthread_getspecific(key);
    printf("thr #2 data2 = %p\n", data);

    return (void *)0;
}

int main()
{
    pthread_t pid1, pid2;
    pthread_key_t key;

    pthread_key_create(&key, mydtor);

    pthread_create(&pid1, NULL, mythr1, (void *)key);
    pthread_create(&pid2, NULL, mythr2, (void *)key);

    pthread_join(pid1, NULL);
    pthread_join(pid2, NULL);

    pthread_key_delete(key);
    return 0;
}
```

运行结果：

```
$ ./a.out 
thr #1 data1 = 0x804c3f0
thr #2 data1 = 0x804c400
thr #2 data2 = 0x804c400
dtor = 0x804c400
thr #1 data2 = 0x804c3f0
dtor = 0x804c3f0
```

[1]:https://github.com/kasicass/blog/blob/master/pthread/2012_03_15_tls_on_mac.md
