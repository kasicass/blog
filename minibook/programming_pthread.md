# Programming PThreads

pthread 标准中定义的所有函数，总算给介绍完了。此文做一个总体索引吧。

个人理解，pthread 作为一个通用的标准，期望其能描述各种应用下多线程的行为。因此，pthread 函数分为普通和实时(realtime)两类，普通就是一般通用操作系统上应该实现的，而实时则是嵌入式操作系统应该实现的。

我个人不做嵌入式开发，关注点也就集中在一般通用操作系统上的用法了。下面是按我个人习惯分的类。

## 留意返回值

pthread 函数返回值的规则，请先看此文。

 * [关于函数返回值][1]

## 常用内容

在通用操作系统上，个人认为比较常用的内容。

### 基本属性

 * [线程的创建与退出][2]
 * [线程属性(4) -- detach state][3]
 * [thread self & equal][4]
 * [thread-specific data][5]
 * [thread cancel][6]

### 同步机制

 * [同步机制(1) -- mutex & mutex attr][7]
 * [同步机制(2) -- rwlock][8]
 * [同步机制(3) -- cond][9]

### 使用实例

 * [使用实例(1) -- FIFO queue][10]
 * [使用实例(2) -- single thread sleep code][11]
 * [使用实例(3) -- 实现 MacOS 下的 TLS][22]

## 不常用内容

属于标准，但不常用的内容。

### 基本属性

 * [线程属性(1) -- user-defined stack & stack guard][12]
 * [线程属性(2) -- sched policy & priority (REALTIME)][13]
 * [线程属性(3) -- scope & inherit sched (REALTIME)][14]
 * [thread concurrency][15]

### 同步机制

 * [同步机制(4) -- barrier (REALTIME)][16]
 * [同步机制(5) -- spin lock (REALTIME)][17]

## FreeBSD 相关

 * [gcc 关于 -pthread 和 -lpthread 的区别][18]
 * [FreeBSD 的几个pthread的实现：libc_r / libkse / libthr][19]
 * [libthr 分析 (1) -- libthr 如何与 libc 合作][20]
 * [libthr 分析 (2) -- thread 的生与死][21]

[1]:https://github.com/kasicass/blog/blob/master/lib-pthread/2009_12_30_func_return_value.md
[2]:https://github.com/kasicass/blog/blob/master/lib-pthread/2009_12_25_thread_create_and_exit.md
[3]:https://github.com/kasicass/blog/blob/master/lib-pthread/2009_12_28_detach_state.md
[4]:https://github.com/kasicass/blog/blob/master/lib-pthread/2009_12_28_thread_self_and_equal.md
[5]:https://github.com/kasicass/blog/blob/master/lib-pthread/2009_12_29_thread_specific_data.md
[6]:https://github.com/kasicass/blog/blob/master/lib-pthread/2009_12_29_thread_cancel.md
[7]:https://github.com/kasicass/blog/blob/master/lib-pthread/2009_12_30_mutex.md
[8]:https://github.com/kasicass/blog/blob/master/lib-pthread/2010_01_06_rwlock.md
[9]:https://github.com/kasicass/blog/blob/master/lib-pthread/2010_01_06_cond.md
[10]:https://github.com/kasicass/blog/blob/master/lib-pthread/2010_01_13_FIFO_queue.md
[11]:https://github.com/kasicass/blog/blob/master/lib-pthread/2010_08_11_thread_sleep_code.md
[12]:https://github.com/kasicass/blog/blob/master/lib-pthread/2009_12_28_user_defined_thread_stack.md
[13]:https://github.com/kasicass/blog/blob/master/lib-pthread/2009_12_28_sched_policy_and_priority.md
[14]:https://github.com/kasicass/blog/blob/master/lib-pthread/2009_12_28_scope_and_inherit_sched.md
[15]:https://github.com/kasicass/blog/blob/master/lib-pthread/2009_12_29_thread_concurrency.md
[16]:https://github.com/kasicass/blog/blob/master/lib-pthread/2010_01_06_barrier.md
[17]:https://github.com/kasicass/blog/blob/master/lib-pthread/2010_01_08_spin_lock.md
[18]:https://github.com/kasicass/blog/blob/master/freebsd/2009_10_24_gcc_pthread.md
[19]:https://github.com/kasicass/blog/blob/master/freebsd/2009_12_15_freebsd8_remove_KSE.md
[20]:https://github.com/kasicass/blog/blob/master/freebsd/2010_12_03_how_libthr_work_with_libc.md
[21]:https://github.com/kasicass/blog/blob/master/freebsd/2010_12_03_libthr_thread_lifecycle.md
[22]:https://github.com/kasicass/blog/blob/master/lib-pthread/2012_03_15_tls_on_mac.md
