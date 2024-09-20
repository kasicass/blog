# [FreeBSD] libthr 分析 (2) -- thread 的生与死

FreeBSD 8.1 release

## thread 对应的一些结构

thread/thr_private.h

 * struct pthread
 * 一个线程所有的信息

thread/thr_list.c or thr_init.c

```C
#define MAX_THREADS         100000        // 一个进程允许的线程数量，理论值。厄。。。
#define MAX_CACHED_THREADS  100
```

* _thread_list, 所有 thread 的 struct pthread {} 链表 (包括已经退出的线程)
* _thread_active_threads, 所有 thread 的个数
* 
* _thread_gc_list, 等待回收的线程
* 
* free_threadq, 可用的 struct pthread {} 的 freelist, 减少 malloc/free
* free_thread_count, freelist 中 struct pthread {} 的个数

```C
// array + single-linked list, 快速查找调用者传入的 struct pthread *
// 看是否存在对应的 struct pthread {}
#define HASH_QUEUES 128
thr_hashtable[HASH_QUEUES];
```

* total_threads, malloc 的 struct pthread {} 的总个数
* 
* _thr_alloc(), 获取一个 struct pthread {}, 先尝试从 free_threadq 里面拿，如果没有了就 malloc()
* _thr_free(), 优先放到 free_threadq 中，如果已经满了(> MAX_CACHED_THREADS), 则直接 free()


## struct pthread {} 的云游

```
  1. 创建，被加入 _thread_list, thr_hashtable
  2. 退出，加入 _thread_gc_list
  3. 释放，移出 _thread_list, thr_hashtable, _thread_gc_list
    <a> 进入 free_threadq, 或者
    <b> 直接 free() 之
```


## 生与死的过程分解

一个线程对应：

  1. one kernel thread (/usr/include/sys/thr.h)
  2. struct pthread {}

pthread_create 的过程：

  1. _thr_alloc(), 得到一个 struct pthread {}
  2. 填写 attr，创建 stack
  3. refcount = 1
  4. struct pthread {} 加入 _thread_list, thr_hashtable
  5. 填写 struct thr_param {}, 然后调用 thr_new() 启动 kernel thread

pthread_exit 的过程：

```
  1. 调用 pthread_cleanup_push() 注册的函数
  2. 清理 specific data
  3. refcount--
  4. 是否 detached 线程
    <a> 是，struct pthread {} 丢到 _thread_gc_list 中
        当 pthread_create() 的时候，如果 free_threadq 中的 struct pthread {} 不够用了，会尝试 gc
        refcount == 0 的 struct pthread {} 会释放，并放入 free_threadq 中
    <b> 否，joinable线程(默认)，不处理 struct pthread {}, 等待 pthread_join()
  5. thr_exit(&tid), 释放 kernel thread
```

pthread_join 的过程：

  1. 找到 target_pthread 并设置 target_pthread.joiner = curthread
  2. 如果 target_pthread 还没退出，sleep
  3. target_pthread 退出，将其的 struct pthread {} 丢到 _thread_gc_list
