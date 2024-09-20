# [ZeroMQ] zmq与libevent等共存的一个bug

仅仅是 zmq_bind / zmq_connect 的顺序问题，可能导致 select() 工作异常。

 * zmq 2.1.0, ZMQ_FD bug
 * pull = zmq_bind(), push = zmq_connect(), libevent + pull, ok!
 * push = zmq_bind(), pull = zmq_connect(), libevent + pull, fail!

让 select() 卡住的例子：

```C++
//// main thread ////
push = zmq_socket(ZMQ_PUSH)
zmq_bind(push)

pull = zmq_socket(ZMQ_PULL)
zmq_connect(pull)
  -> zmq::socket_base_t::connect()
     -> send_bind()                 // send 'bind' to push.mailbox

start thread 2

sleep(1);
while (1)
{
        zmq_send(push);
}

//// thread 2 ////
fd = zmq_getsockopt(pull, ZMQ_FD);

while (1)
{
    select(fd for read);
    zmq_getsockopt(pull, ZMQ_EVENTS);
    while (1) zmq_recv(pull, ZMQ_NOBLOCK);
}

// ======== sequence chart ========
//
// main thread:
//   zmq_send(push);        // push_t::xsend()
//                          //  -> lb_t::send()
//                          //     -> writer_t::flush()
//                          //        -> ypipe_t::flush()
//                          //           -> c.cas (w, f) != w
//                          //              (Compare-and-swap was unseccessful because 'c' is NULL.)
//                          //              (no 'activate_reader' to pull.mailbox)
//
// thread 2 (first loop):
//   select(fd for read);   // block here, as no 'activate_reader' message
//   ...
```

正常工作的例子：

```C++
//// main thread ////
pull = zmq_socket(ZMQ_PULL)
zmq_bind(pull)

push = zmq_socket(ZMQ_PUSH)
zmq_connect(push)
  -> zmq::socket_base_t::connect()
     -> send_bind()                 // send 'bind' to pull.mailbox

start thread 2

sleep(1)
while (1)
{
    zmq_send(push);
}

//// thread 2 ////
fd = zmq_getsockopt(pull, ZMQ_FD);

while (1)
{
    select(fd for read);
    zmq_getsockopt(pull, ZMQ_EVENTS);
    while (1) zmq_recv(pull, ZMQ_NOBLOCK);
}

// ======== sequence chart ========
//
// thread 2 (first loop):
//   select(fd for read);                // got 'bind' message
//   zmq_getsockopt(pull, ZMQ_EVENTS);   // socket_base_t::process_commands()
//                                       //  -> pull attach
//                                       // pull_t::xhas_in()
//                                       //  -> fq_t::has_in()
//                                       //     -> ypipe_t::check_read()
//                                       //        -> c.cas (&queue.front (), NULL);    // c = NULL
//   zmq_recv(pull, ZMQ_NOBLOCK);        // do nothing, goto to select() again
//
// main thread:
//   zmq_send(push);                     // push_t::xsend()
//                                       //  -> lb_t::send()
//                                       //     -> writer_t::flush()
//                                       //        -> ypipe_t::flush()
//                                       //           -> c.cas (w, f) != w
//                                       //              (Compare-and-swap was unseccessful because 'c' is NULL.)
//                                       //        -> send 'activate_reader' to pull.mailbox
//
// second loop:
//   select(fd for read);                // got 'activate_reader' message
//   zmq_getsockopt(pull, ZMQ_EVENTS);   // socket_base_t::process_commands()
//                                       //  -> fq_t::activated()
//                                       // pull_t::xhas_in() / set 'ZMQ_POLLIN'
//   zmq_recv(pull, ZMQ_NOBLOCK);        // consuming all zmq_msg_t
```

ps. 不过 ZeroMQ 的开发者不认为这是个 bug。而认为我将 edge-triggered 的 socket 当 level-triggered 来使用了。（reader_t 默认为 readable，所以 select() 听不到任何事件，厄）

```
I would say the problem is that you are using ZMQ_FD as if it was level-triggered. In fact it is edge triggered. 

I.e. you should get ZMQ_EVENTS to find out whether particular 0MQ socket is readeable/writeable. 

Further on poll(ZMQ_FD) signals event only if the state changes. For example if the socket was unreadable and become readable. If the socket was readable and remains readable, ZMQ_FD is not signaled. 

Martin
```

说得也对，但这让我写 libevent + zeromq 的时候，很纠结。
