# [pthread] 线程的属性(1) -- user-defined stack & stack guard

pthread_attr_t 决定了线程被创建时具有何种属性。同时，pthread 提供了一组 pthread_attr_* 函数来操作线程的属性。一旦创建后，此线程的属性是不能被修改的。

其中一块属性是 stackaddr, stacksize。就是允许自定义 memory 作为 stack，而不需要 pthread 内部为你分配，因为某些系统可能只允许将 stack 放在某块 memory region，当然，我还没碰到过此情况。

如果 stackaddr == NULL, 则 pthread lib 在创建内核线程前，会自动为你创建 stack。

下面的例子可以看到，线程使用了我们指定的 stack。（注意，stack 使用是从高地址 ==> 低地址）

```C
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <pthread.h>

void *mythr(void *arg)
{
    ptrdiff_t d = (void *)&arg - (void *)arg;
    printf("stack  = %p\n", arg);
    printf("arg    = %p\n", &arg);
    printf("d      = %p\n", &d);
    printf("val(d) = %d\n", d);
    return (void *)0;
}

int main()
{
    void *stack = malloc(PTHREAD_STACK_MIN*2);

    pthread_t pid;
    pthread_attr_t attr;
    pthread_attr_init(&attr);

    printf("PTHREAD_STACK_MIN = %d\n", PTHREAD_STACK_MIN);

    // user-defined stack
    pthread_attr_setstackaddr(&attr, stack);
    pthread_attr_setstacksize(&attr, PTHREAD_STACK_MIN*2);
    pthread_create(&pid, &attr, mythr, stack);
    pthread_join(pid, NULL);

    pthread_attr_destroy(&attr);
    free(stack);
    return 0;
}
```

```
$ ./a.out 
PTHREAD_STACK_MIN = 2048
stack  = 0x8056000
arg    = 0x8056fc0
d      = 0x8056fb4
val(d) = 4032
```

新一点的标准还提供了 pthread_attr_getstack/setstack，同时操作两者。原因如下：
* [http://www.opengroup.org/platform/resolutions/bwg2000-003.html][1]

pthread 中还可以让你设置 stack guard。pthread_attr_setguardsize / getguardsize。

线程的 stack 如下：

```
high addr      | stack ..... | guard ... |       low addr
```

可以将 guard 部分的内存 mmap 为不可读/写。当 stack overflow 时，则收到 SIGSEGV。

对于上面的 user-defined stack，无论是否设置 guardsize，pthread 都忽略之。

[1]:http://www.opengroup.org/platform/resolutions/bwg2000-003.html
