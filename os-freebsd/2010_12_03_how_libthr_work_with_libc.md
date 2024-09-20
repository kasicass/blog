# [FreeBSD] libthr 分析 (1) -- libthr 如何与 libc 合作

FreeBSD 8.1 release

## libc 提供的 hook

先看一下 gcc 的 weak ref 概念：

 * [http://www.cnblogs.com/kernel_hcy/archive/2010/01/27/1657411.html][1]

libc 提供了 __thr_jtable[] 的定义，作为 pthread func 挂接的 hook。

```C
// lib/libc/include/libc_private.h
typedef enum {
    PJT_ATFORK,
    PJT_ATTR_DESTROY,
    PJT_MAX
} pjt_index_t;

typedef int (*pthread_func_t)(void);
typedef pthread_func_t pthread_func_entry_t[2];

extern pthread_func_entry_t __thr_jtable[];
```

定义了 __thr_jtable[] 的 stubs 版本，对于 single-thread 的程序，保证 pthread_self() 可以使用。

```C
// lib/libc/gen/_pthread_stubs.c

alias: (_exp = export, _int = internal)
  pthread_create(...) ==> pthread_create_exp(...)
  _pthread_create(...) ==> pthread_create_int(...)
```

大部分情况，_exp, _int 实际上是指向同一个版本，就不细究两者的区别了。

我们调用 pthread_create() 实际上是调用 pthread_create_exp() 然后调用到 __thr_jtable[] 中对应的函数。


## lib/libthr/*

__thr_jtable[] 的 libthr 版本

 * 定义在 thread/thr_init.c
 * _libpthread_init(struct pthread *curthread) (thread/thr_init.c)

_libpthread_init() 函数，初始化 libthr。

  1. 在第一次调用 pthread_create(), pthread_mutex_lock(), .. 等函数时触发
  2. fork 时调用，curthread != NULL

spinlock 的实现

 * thread/thr_spinlock.c
 * spinlock 也是用 week ref 的机制
 * 对于 single-thread 程序，是个空函数
 * 而 multi-thread 下有具体实现。
 * spinlock 主要用于 malloc() 里。


[1]:http://www.cnblogs.com/kernel_hcy/archive/2010/01/27/1657411.html