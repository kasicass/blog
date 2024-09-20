# [pthread] 使用实例(1) -- FIFO queue

多线程最常用的结构就是 producer/consumer，而跨线程通讯，则需要一个 lockable queue。下面就是一个 FIFO queue 的实现。:-)

```C
// thread-safe FIFO queue (thr_queue.h)

#ifndef KCODE_THREAD_QUEUE_H
#define KCODE_THREAD_QUEUE_H

#include <sys/types.h>          // size_t
#include <pthread.h>

struct thr_queue_s;
typedef struct thr_queue_s      *thr_queue_t;

int thr_queue_create(thr_queue_t *q, size_t max_size);          // 0, ok; -1, fail
void thr_queue_destroy(thr_queue_t *q);

void thr_queue_push(thr_queue_t *self, void *in);
void thr_queue_pop(thr_queue_t *self, void **out);
size_t thr_queue_size(const thr_queue_t *self);
size_t thr_queue_capacity(const thr_queue_t *self);

#endif
```

```C
// thr_queue.c
#include <stdlib.h>             // malloc
#include "thr_queue.h"

struct thr_queue_s {
    void ** _queue;

    size_t _max_size;
    size_t _cur_size;
    size_t _head;
    size_t _tail;

    pthread_mutex_t _mutex;
    pthread_cond_t _cond_avail;     // signal when queue is not full, can push more
    pthread_cond_t _cond_have;      // signal when queue is not empty, can pop
};

// ---------------- Create/Destroy -------------------
int thr_queue_create(thr_queue_t *q, size_t max_size)
{
    struct thr_queue_s *queue = (struct thr_queue_s *) malloc(sizeof(struct thr_queue_s));

    if (queue == NULL) {
        return -1;
    }

    queue->_queue = (void **) malloc(max_size * sizeof(void *));
    if (queue->_queue == NULL) {
        free(queue);
        queue = NULL;
        return -1;
    }

    queue->_max_size = max_size;
    queue->_cur_size = queue->_head = queue->_tail = 0;

    pthread_mutex_init(&queue->_mutex, NULL);
    pthread_cond_init(&queue->_cond_avail, NULL);
    pthread_cond_init(&queue->_cond_have, NULL);

    *q = queue;
    return 0;
}

void thr_queue_destroy(thr_queue_t *q)
{
    struct thr_queue_s *queue;

    if ( q == NULL || *q == NULL )
        return;

    queue = *q;

    pthread_cond_destroy(&queue->_cond_have);
    pthread_cond_destroy(&queue->_cond_avail);
    pthread_mutex_destroy(&queue->_mutex);

    free(queue->_queue);
    free(queue);
}


// ---------------- push/pop -------------------
size_t thr_queue_size(const thr_queue_t *self)
{
    return (*self)->_cur_size;
}

size_t thr_queue_capacity(const thr_queue_t *self)
{
    return (*self)->_max_size;
}

void thr_queue_push(thr_queue_t *q, void *in)
{
    struct thr_queue_s *self = *q;
    pthread_mutex_lock(&self->_mutex);

    while (self->_cur_size == self->_max_size)
    {
        // full? wait it
        pthread_cond_wait(&self->_cond_avail, &self->_mutex);
    }

    self->_queue[self->_tail++] = in;
    if (self->_tail == self->_max_size)
    {
        self->_tail = 0;
    }

    if (self->_cur_size++ == 0)
    {
        // not empty? wakeup pop()
        pthread_cond_signal(&self->_cond_have);
    }

    pthread_mutex_unlock(&self->_mutex);
}

void thr_queue_pop(thr_queue_t *q, void **out)
{
    struct thr_queue_s *self = *q;
    pthread_mutex_lock(&self->_mutex);

    while (self->_cur_size == 0)
    {
        // empty? wait
        pthread_cond_wait(&self->_cond_have, &self->_mutex);
    }

    if (out)
    {
        *out = self->_queue[self->_head];
    }

    self->_head++;
    if (self->_head == self->_max_size)
    {
        self->_head = 0;
    }

    if (self->_cur_size-- == self->_max_size)
    {
        // not full? wakeup push()
        pthread_cond_signal(&self->_cond_avail);
    }

    pthread_mutex_unlock(&self->_mutex);
}
```

FIFO queue 的使用实例如下

```C
#include <stdio.h>
#include "thr_queue.h"

thr_queue_t workq;

void *producer(void *arg)
{
    int n = 20;
    int v = (int)arg;
    while ( n-- > 0 )
    {
        thr_queue_push(&workq, (void *)(v*1000 + n));
    }

    return (void *)0;
}

void *consumer(void *_)
{
    int n;
    while (1)
    {
        thr_queue_pop(&workq, (void **)&n);
        if ( n == -100 ) break;

        printf("getn = %d\n", n);
    }

    return (void *)0;
}

int main()
{
    pthread_t pid1, pid2, pid3;
    thr_queue_create(&workq, 5);

    pthread_create(&pid1, NULL, producer, (void *)1);
    pthread_create(&pid2, NULL, producer, (void *)2);
    pthread_create(&pid3, NULL, consumer, NULL);

    pthread_join(pid1, NULL);
    pthread_join(pid2, NULL);

    thr_queue_push(&workq, (void *)-100);   // make consumer exit
    pthread_join(pid3, NULL);
    return 0;
}
```

```
$ ./a.out 
getn = 1019
getn = 1018
getn = 1017
getn = 2019
getn = 1016
getn = 2018
getn = 1015
getn = 1014
getn = 2017
getn = 1013
getn = 1012
getn = 1011
getn = 2016
```
