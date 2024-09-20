# 关于linux下面lsof会出现"can't identify protocol"  

## 问题

用 lsof 会看到 "can't identify protocol" 的 socket fd，很奇怪，啥情况下会这样呢？
不求甚解下，google 了一把，得到了个错误的结论：

[http://www.linuxquestions.org/questions/linux-networking-3/lsof-cant-identify-protocol-sock-178283/][1]

先翻了下 lsof 的代码，发现 "can't identify protocol" 在 lsof_4.82_src/dialects/linux/dsock.c 下，说明这串文字并**不是**从 linux kernel 里面出来的。

## 试验过程

### sock1.c

写了个简单的小程序，用 lsof 看一下。

```C
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/resource.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <unistd.h>
#include <assert.h>
#include <string.h>

int main()
{
    int fd, r;
    struct sockaddr_in sa;
    fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    sleep(60);
    return 0;
}
```

在 openbsd 下：

```
COMMAND  PID     USER   FD   TYPE     DEVICE SIZE/OFF  NODE NAME
a.out   1649 kasicass    3u  IPv4 0xd51d9af4      0t0   TCP *:* (CLOSED)
```

在 debian 下：

```
COMMAND  PID     USER   FD   TYPE DEVICE    SIZE   NODE NAME
a.out   2356 kasicass    3u  sock    0,4          42992 can't identify protocol
```

很奇怪哦，正确创建的 socket fd 居然显示 "can't identify protocol"。

### sock2.c

然后我增加一个 connect() 看看。

```C
int main()
{
    int fd, r;
    struct sockaddr_in sa;

    fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

    memset(&sa, 0, sizeof(sa));
    sa.sin_addr.s_addr = inet_addr("192.168.0.88");
    sa.sin_family      = AF_INET;
    sa.sin_port        = htons(2224);
    r = connect(fd, (struct sockaddr *)&sa, sizeof(sa));
    assert(r != -1);
    close(fd);

    sleep(60);
    return 0;
}
```

在 debian 下，连接成功：

```
a.out   2979 kasicass    3u  IPv4  44790      0t0    TCP 10.0.2.15:58282->192.168.0.88:2224 (ESTABLISHED)
```

如果连接不成功：

```
a.out   3001 kasicass    3u  IPv4  44885      0t0    TCP 10.0.2.15:58283->192.168.0.88:2224 (SYN_SENT)
```

### sock3.c

恩，再试了下 listen() 的情况：

```C
static int bind_and_listen(int fd, int port)
{
	struct sockaddr_in in_addr;
    int reuseaddr_on = 1;

    // addr reuse
    if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (const char *)&reuseaddr_on, sizeof(reuseaddr_on)) == -1)
        return -1;

    // bind & listen
    bzero(&in_addr, sizeof(in_addr));
    in_addr.sin_family      = AF_INET;
    in_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    in_addr.sin_port        = htons(port);

    if ( bind(fd, (struct sockaddr *) &in_addr, sizeof(in_addr)) == -1 )
        return -1;

    if ( listen(fd, 64) == -1 )
        return -1;

    return fd;
}

int main()
{
    int fd, r;

    fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    r  = bind_and_listen(fd, 2224);
    assert(r != -1);

    sleep(60);
    return 0;
}
```

如果 bind + listen 结果是：

```
a.out   3052 kasicass    3u  IPv4  45083      0t0    TCP *:2224 (LISTEN)
```

如果只是 bind 则：

```
a.out   3074 kasicass    3u  sock    0,4      0t0  45174 can't identify protocol
```

## 结论

没有再细致去看代码，不过可以推断，linux 下，lsof 对于没有 connect() or listen() 的 socket fd，都是显示 "can't identify protocol"。

而bsd下则会正确显示出 socket type。

ps. 据说shutdown后没有close会出现这个情况，待验证。:-)


[1]:http://www.linuxquestions.org/questions/linux-networking-3/lsof-cant-identify-protocol-sock-178283/
