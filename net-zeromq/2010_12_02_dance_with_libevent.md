# [ZeroMQ] 与 libevent 协同工作 (2.1.0 release)

2.1.0 解决掉两个大问题：

  1. 和其他 poll 机制共存的问题，比如：libevent
  2. zmq_term() 会保证所有消息发送完全，不再需要 sleep(1) 了。（前提是所有的 zmqsocket 都要正确地 zmq_close()，否则 zmq_term() 会一直 block。zmq_term() 的时候，会给所有的 zmq_recv() 的地方发送 -1 + ETERM，要正确处理此逻辑。

zeromq + libevent 真是很爽的组合。

### 服务端(server.c)

```C++
#include <zmq.h>
#include <event.h>
#include <stdio.h>

void pair_callback(int _, short __, void *pair)
{
    zmq_msg_t msg;
    uint32_t events;
    size_t len;

    len = sizeof(events);
    zmq_getsockopt(pair, ZMQ_EVENTS, &events, &len);

    if ( events & ZMQ_POLLIN )
    {
        while (1)
        {
            zmq_msg_init(&msg);
            if ( zmq_recv(pair, &msg, ZMQ_NOBLOCK) == -1 )
            {
                zmq_msg_close(&msg);
                break;
            }
            printf("recv: %s\n", (char *)zmq_msg_data(&msg));
            zmq_msg_close(&msg);
        }
    }
}

int main()
{
    struct event_base *evbase;
    struct event *ev;
    void *ctx, *pair;
    int pairfd;
    size_t len;

    ctx  = zmq_init(1);
    pair = zmq_socket(ctx, ZMQ_PULL);
    zmq_bind(pair, "tcp://127.0.0.1:6666");

    len = sizeof(pairfd);
    zmq_getsockopt(pair, ZMQ_FD, &pairfd, &len);

    evbase = event_base_new();
    ev = event_new(evbase, pairfd, EV_READ|EV_PERSIST, pair_callback, pair);
    event_add(ev, NULL);

    event_base_dispatch(evbase);
    return 0;
}
```

### 客户端(client.c)

```C++
#include <zmq.h>
#include <string.h>

int main()
{
    void *ctx, *pair;
    zmq_msg_t msg;

    ctx  = zmq_init(1);
    pair = zmq_socket(ctx, ZMQ_PUSH);
    zmq_connect(pair, "tcp://127.0.0.1:6666");

    zmq_msg_init_size(&msg, 6);
    memcpy(zmq_msg_data(&msg), "hello", 6);
    zmq_send(pair, &msg, 0);
    zmq_msg_close(&msg);

    zmq_close(pair);
    zmq_term(ctx);
    return 0;
}
```

ps. 不过这里有个需要注意的地方

 * http://kasicass.blog.163.com/blog/static/3956192010111662323140/
