# [ZeroMQ] Hello World

本来是在看 RabbitMQ 的，然后看到 OpenAMQ，简单看了看 AMQP 协议结构，还是有点重。然后发现了 ZeroMQ。

 * [http://www.zeromq.org/][1]

看了 cookbook，上面的例子很对我胃口。喜欢这样介乎于轻量级 libevent 和重量级 ACE 之间的库。

 * [http://www.zeromq.org/docs:cookbook][2]

看看 Echo Server 如何实现：

-----------------------

```C++
// server.c
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <zmq.h>

int main()
{
    int rc;
    void *ctx, *s;
    zmq_msg_t query, resultset;
    const char *query_string, *resultset_string = "ok";

    ctx = zmq_init(1);
    assert(ctx);

    s = zmq_socket(ctx, ZMQ_REP);
    assert(s);

    rc = zmq_bind(s, "tcp://127.0.0.1:5555");
    assert(rc == 0);

    while (1)
    {
        rc = zmq_msg_init(&query);
        assert(rc == 0);

        rc = zmq_recv(s, &query, 0);
        assert(rc == 0);

        query_string = (const char *)zmq_msg_data(&query);
        printf("recv: %s\n", query_string);
        zmq_msg_close(&query);

        rc = zmq_msg_init_size(&resultset, strlen(resultset_string)+1);
        assert(rc == 0);
        
        memcpy(zmq_msg_data(&resultset), resultset_string, strlen(resultset_string)+1);

        rc = zmq_send(s, &resultset, 0);
        assert(rc == 0);
        zmq_msg_close(&resultset);
    }

    return 0;
}
```

-----------------------

```C++
// client.c
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <zmq.h>

int main()
{
    int rc;
    void *ctx, *s;
    const char *query_string = "hello ZeroMQ.";
    zmq_msg_t query, resultset;

    ctx = zmq_init(1);
    assert(ctx);

    s = zmq_socket(ctx, ZMQ_REQ);
    assert(s);

    rc = zmq_connect(s, "tcp://127.0.0.1:5555");
    assert(rc == 0);

    // send
    rc = zmq_msg_init_size(&query, strlen(query_string)+1);
    assert(rc == 0);
    memcpy(zmq_msg_data(&query), query_string, strlen(query_string)+1);

    rc = zmq_send(s, &query, 0);
    assert(rc == 0);
    zmq_msg_close(&query);

    // recv
    rc = zmq_msg_init(&resultset);
    assert(rc == 0);

    rc = zmq_recv(s, &resultset, 0);
    assert(rc == 0);

    printf("ack: %s\n", (const char *)zmq_msg_data(&resultset));
    zmq_msg_close(&resultset);

    zmq_close(s);
    zmq_term(ctx);
    return 0;
}
```

用起来很简洁，不错不错。

例子同时说明了 ZeroMQ 中的 request / reply 模式，客户端 ZMQ_REQ、服务端 ZMQ_REP。


[1]:http://www.zeromq.org/
