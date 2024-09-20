# ZeroMQ Demystify

所有分析，基于 2.1.0 的代码。


## 简介

 * 建立在 socket 之上的 light-weight message queue
 * 不再需要自己管理 tcp 分包
 * 简单、实用

业务背景

 * 来自 iMatix 的一个库
 * iMatix 主要面向金融行业（业务逻辑决定设计）
 * [http://www.zeromq.org/][1]
 * [http://zguide.zeromq.org/chapter:all][2]


## 基本用法

 * [Hello 0MQ, Echo Server][3]
 * [Multi-part Messages][4]
 * 
 * [messaging pattern (1) -- publish/subscribe][5]
 * [messaging pattern (2) -- pipeline][6]
 * 
 * [与 libevent 协同工作][7]
 * [与 libevent 协同工作的注意事项][8]


## 性能测试

 * ["inproc://" Performance][9]


## ZeroMQ 源码分析

 * [深入分析(1) -- 几个基础数据结构][10]
 * [深入分析(2) -- 线程间通讯"inproc://"][11]
 * [深入分析(3) -- 进程间通讯"tcp://"][12]


## 其他

 * 广州techparty演讲稿(下载ppt.zip)
 * [https://github.com/kasicass/kasicass/tree/master/zmq/intro][13]
 * 
 * 关于SIGPIPE
 * [http://lists.zeromq.org/pipermail/zeromq-dev/2010-July/004238.html][14]
 * 
 * nonomsg, zeromq作者抛弃C++之后，用C重新实现zeromq
 * [http://nanomsg.org/][15]

其他人的分析

 * SecondLife对message-queue的总结
 * [http://wiki.secondlife.com/wiki/Message_Queue_Evaluation_Notes#Zero_MQ][16]
 * 
 * 公司一位同事对AMQP和ZeroMQ的分析
 * [https://docs.google.com/present/view?id=df85d3vm_316dbhtg3f7][17]


[1]:http://www.zeromq.org/
[2]:http://zguide.zeromq.org/chapter:all
[3]:https://github.com/kasicass/blog/blob/master/net-zeromq/2010_08_31_hello_world_zmq.md
[4]:https://github.com/kasicass/blog/blob/master/net-zeromq/2010_09_01_multipart_message.md
[5]:https://github.com/kasicass/blog/blob/master/net-zeromq/2010_11_03_pub_sub.md
[6]:https://github.com/kasicass/blog/blob/master/net-zeromq/2010_11_25_pipeline.md
[7]:https://github.com/kasicass/blog/blob/master/net-zeromq/2010_12_02_dance_with_libevent.md
[8]:https://github.com/kasicass/blog/blob/master/net-zeromq/2010_12_16_dance_with_libevent_bug.md
[9]:https://github.com/kasicass/blog/blob/master/net-zeromq/2010_12_20_inproc_performance.md
[10]:https://github.com/kasicass/blog/blob/master/net-zeromq/2010_12_09_zmq_internals_01.md
[11]:https://github.com/kasicass/blog/blob/master/net-zeromq/2010_12_17_zmq_internals_02.md
[12]:https://github.com/kasicass/blog/blob/master/net-zeromq/2010_12_18_zmq_internals_03.md
[13]:https://github.com/kasicass/kasicass/tree/master/zmq/intro
[14]:http://lists.zeromq.org/pipermail/zeromq-dev/2010-July/004238.html
[15]:http://nanomsg.org/
[16]:http://wiki.secondlife.com/wiki/Message_Queue_Evaluation_Notes#Zero_MQ
[17]:https://docs.google.com/present/view?id=df85d3vm_316dbhtg3f7
