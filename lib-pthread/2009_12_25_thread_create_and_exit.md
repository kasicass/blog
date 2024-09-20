# [pthread] 线程的创建与退出

有时候需要写 pthread 程序，一会半会找不到几个简单的 sample 来参考。还是自己专门记录几篇文字，备查吧。:-)

简单创建一个线程，并等待其退出。

```C
#include <pthread.h>
#include <stdio.h>

void *mythr(void *arg)
{
    printf("hello world! %d\n", (int)arg);

    // 这里写 pthread_exit((void *) 4); 和下面的效果一样
    return (void *)4;
}

int main()
{
    pthread_t pid;
    void *ret;

    pthread_create(&pid, NULL, mythr, (void *)3);   // 第二个参数是 attr
    pthread_join(pid, &ret);   // 等待线程结束，第二个参数是 return_value
    printf("done! = %d\n", (int)ret);
    return 0;
}
```

```
$ ./a.out 
hello world! 3
done! = 4
```

如果我们希望线程退出时，自动清理一些资源，可以用 pthread_cleanup_push() 来增加"退出时调用的 cleanup 函数"。而 pthread_cleanup_pop() 可以 cleanup_func_stack 顶的函数 pop 出来。

```C
#include <pthread.h>
#include <stdio.h>

void mycleanup(void *arg)
{
    printf("cleaner = %d\n", (int)arg);
}

void *mythr(void *arg)
{
    pthread_cleanup_push(mycleanup, (void *)1);
    pthread_cleanup_push(mycleanup, (void *)2);

    pthread_cleanup_pop(1);         // 1 - exec cleanup func, 0 - no exec

    printf("hello world! %d\n", (int)arg);
    return (void *)4;
}

int main()
{
    pthread_t pid;
    void *ret;

    pthread_create(&pid, NULL, mythr, (void *)3);
    pthread_join(pid, &ret);
    printf("done! = %d\n", (int)ret);
    return 0;
}
```

```
$ ./a.out 
cleaner = 2
hello world! 3
cleaner = 1
done! = 4
```

注意：
 * 不能对一个 pid 多次 pthread_join
 * 不能在 cleanup func 中调用 pthread_exit
