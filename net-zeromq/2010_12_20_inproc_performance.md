# [ZeroMQ] "inproc://" performance

对比了下 "inproc://" (lock-free queue) 与我原来写的 [thr_queue][1]，在线程间通讯的开销。

Amazing，在数据量很大的情况下，ZeroMQ 快很多。

zmqtest.c 代码

```C++
#include "timer.h"
#include <zmq.h>
#include <unistd.h>
#include <stdio.h>
#include <pthread.h>

#define MSGCNT  (1024*1024)

void *thread_func(void *ctx)
{
  void *pair;
  zmq_msg_t msg;

  pair = zmq_socket(ctx, ZMQ_PAIR);
  zmq_connect(pair, "inproc://workers");

  while (1)
  {
    zmq_msg_init(&msg);
    zmq_recv(pair, &msg, 0);
    if ( *((int *)zmq_msg_data(&msg)) == MSGCNT )
      break;
    zmq_msg_close(&msg);
  }

  tend();
  zmq_close(pair);

  printf("%f\n", tval());
  return (void *)0;
}

int main()
{
  pthread_t tid;
  zmq_msg_t msg;
  void *ctx, *pair;
  int i;

  ctx = zmq_init(0);
  pair = zmq_socket(ctx, ZMQ_PAIR);
  zmq_bind(pair, "inproc://workers");

  pthread_create(&tid, NULL, thread_func, ctx);

  tstart();
  for ( i = 1; i <= MSGCNT; i++ )
  {
    zmq_msg_init_size(&msg, sizeof(int));
    *((int *)zmq_msg_data(&msg)) = i;
    zmq_send(pair, &msg, 0);
    zmq_msg_close(&msg);
  }

  pthread_join(tid, NULL);

  zmq_close(pair);
  zmq_term(ctx);
  return 0;
}
```


thr.c 代码

```C++
#include "thr_queue.h"
#include "timer.h"
#include <stdio.h>

#define MSGCNT  (1024*1024)

thr_queue_t workq;

void *thread_func(void *_)
{
  void *out;
  int n;
  while (1)
  {
    thr_queue_pop(&workq, &out);
    n = (int)out;
    if ( n == MSGCNT ) break;
  }

  tend();
  printf("%f\n", tval());

  return (void *)0;
}

int main()
{
  int i;
  pthread_t tid;

  thr_queue_create(&workq, MSGCNT);
  pthread_create(&tid, NULL, thread_func, NULL);

  tstart();
  for ( i = 1; i <= MSGCNT; i++ )
  {
    thr_queue_push(&workq, (void *)i);
  }

  pthread_join(tid, NULL);
  return 0;
}
```

运行结果

```
 zmqtest              thr
0.438140           12.378115
0.445820           11.966540
0.440500           12.958700
```

运行过程中，zmqtest 每个线程的 cpu 占用都是 0%；而 thr 的线程 cpu 消耗大约在 67%。

 * 线程间传递了 1024*1024 个 pointer。同一台硬件上，ZeroMQ快很多。
 * 操作系统 FreeBSD 6.4 (libkse)、FreeBSD 8.1 (libthr) 都测试了下，结果一样。
 * 看来 lock-free queue 的力量还是很强大滴。


[1]:https://github.com/kasicass/blog/blob/master/pthread/2010_01_13_FIFO_queue.md
