# [pthread] thread cancel

线程A中调用 pthread_cancel(pid_b) 可以让线程pid_b尝试退出。而 pid_b 何时会真正退出，则取决于它的 cancel state & type。函数 pthread_setcancelstate, pthread_setcanceltype 可以用于设置此 state & type，注意，这两个函数是设置当前线程(calling thread)的。

### cancel state

* PTHREAD_CANCEL_ENABLE, 受 pthread_cancel 影响。
* PTHREAD_CANCEL_DISABLE, 不受 pthread_cancel 影响，不退出。

### cancel type

* 只有当 state == ENABLE 时，type 才会起作用。
* PTHREAD_CANCEL_DEFERRED, 只有当"被退出的线程(thread being cancel)"碰到一些 cancel point 时，才退出。
* PTHREAD_CANCEL_ASYNCHRONOUS, pthread_cancel 一调用，"被退出的线程"立即退出。

### cancel point

 * 退出点，一些系统调用都是 cancel point，比如：close(), sleep() 等等。
 * 具体可以系统的查询 man page。
 * 我们也可以用 pthread_testcancel(), 自定义 cancel point。
 * 每个线程创建时，默认是 **ENABLE**, **DEFERRED**。

线程的退出策略，要依据具体的情况而定。我一般都是给线程发送退出指令，让其主动退出，而不使用上面说的 thread cancel 策略。

```C
#include <unistd.h>
#include <stdio.h>
#include <time.h>
#include <pthread.h>

void *mythr_nocancel(void *_)
{
    pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL);
    printf("mythr_nocancel before sleep, %d\n", time(NULL));
    sleep(3);
    printf("mythr_nocancel after sleep, %d\n", time(NULL));
    return (void *)0;
}

void *mythr_defercancel(void *_)
{
    time_t beg, end;

    pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL);
    pthread_setcanceltype(PTHREAD_CANCEL_DEFERRED, NULL);

    // busy run for 5 sec
    beg = time(NULL);
    printf("mythr_defercancel before busy, %d\n", beg);
    do {
        end = time(NULL);
    } while ( end - beg < 5 );      // busy 5 sec
    printf("mythr_defercancel after busy, %d\n", time(NULL));

    // sleep 5 sec (cancel point)
    printf("mythr_defercancel before sleep, %d\n", time(NULL));
    sleep(5);
    printf("mythr_defercancel after sleep, %d\n", time(NULL));

    return (void *)0;
}

void *mythr_asynccancel(void *_)
{
    time_t beg, end;

    pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL);
    pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, NULL);

    beg = time(NULL);
    printf("mythr_asynccancel before busy, %d\n", beg);
    do {
        end = time(NULL);
    } while ( end - beg < 5 );      // busy 5 sec
    printf("mythr_asynccancel after busy, %d\n", time(NULL));
    return (void *)0;
}

void *mythr_testcancel(void *_)
{
    pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL);
    pthread_setcanceltype(PTHREAD_CANCEL_DEFERRED, NULL);
    printf("mythr_testcancel enter, %d\n", time(NULL));
    while (1) pthread_testcancel();
    printf("mythr_testcancel leave, %d\n", time(NULL));
    return (void *)0;
}

int main()
{
    pthread_t pid;

    pthread_create(&pid, NULL, mythr_nocancel, NULL);
    sleep(1);
    pthread_cancel(pid);
    pthread_join(pid, NULL);

    pthread_create(&pid, NULL, mythr_defercancel, NULL);
    sleep(1);
    pthread_cancel(pid);
    pthread_join(pid, NULL);

    pthread_create(&pid, NULL, mythr_asynccancel, NULL);
    sleep(1);
    pthread_cancel(pid);
    pthread_join(pid, NULL);

    pthread_create(&pid, NULL, mythr_testcancel, NULL);
    sleep(2);
    pthread_cancel(pid);
    pthread_join(pid, NULL);

    return 0;
}
```

运行结果

```C
$ ./a.out 
mythr_nocancel before sleep, 1262092394
mythr_nocancel after sleep, 1262092397
mythr_defercancel before busy, 1262092397
mythr_defercancel after busy, 1262092402
mythr_defercancel before sleep, 1262092402
mythr_asynccancel before busy, 1262092402
mythr_testcancel enter, 1262092403
```
