# [pthread] single thread sleep code

在 RakNet 中看到的，挺实用，hoho。

```C
void RakSleep(unsigned int ms)
{
    // Single thread sleep code thanks to Furquan Shaikh
    // http://somethingswhichidintknow.blogspot.com/2009/09/sleep-in-pthread.html
    // Modified slightly from the original
    pthread_mutex_t fakeMutex = PTHREAD_MUTEX_INITIALIZER;
    pthread_cond_t fakeCond = PTHREAD_COND_INITIALIZER;
    struct timespec timeToWait;
    struct timeval now;
    int rt;

    gettimeofday(&now,NULL);

    long seconds = ms/1000;
    long nanoseconds = (ms - seconds * 1000) * 1000000;
    timeToWait.tv_sec = now.tv_sec + seconds;
    timeToWait.tv_nsec = now.tv_usec*1000 + nanoseconds;
 
    if (timeToWait.tv_nsec >= 1000000000)
    {
        timeToWait.tv_nsec -= 1000000000;
        timeToWait.tv_sec++;
    }

    pthread_mutex_lock(&fakeMutex);
    rt = pthread_cond_timedwait(&fakeCond, &fakeMutex, &timeToWait);
    pthread_mutex_unlock(&fakeMutex);
}
```

并没有碰到过使用场景。

```
f.f.:
  怎么用，单纯ms级的sleep？

kasicass:
  一个进程中有多个 thread 在跑，只让其中一个 thread sleep 的函数。在此 thread 调用此函数即可。

f.f.:
  遇到了在某线程中sleep导致所有线程都sleep的bug？所以才用这个？不明白为什么不直接用sleep？

kasicass:
  厄 ... 不知，只是看到了代码，mark 一下。
  - -!

kasicass:
  Using any variant of sleep for pthreads, the behaviour is not guaranteed. All the threads can also sleep since the kernel is not aware of the different threads. Hence a solution is required which the pthread library can handle rather than the kernel.

  估计是这个原因：All the threads can also sleep since the kernel is not aware of the different threads.

f.f.:
  嗯。。。什么系统呢？所有的*nix?

kasicass:
  厄，木研究过。碰到再说。
```
