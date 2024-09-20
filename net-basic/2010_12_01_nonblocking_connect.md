# nonblocking connect()

厄，nonblocking connect 到一个不存在的 ip:port，linux 下 select() writable 不会立即返回，而 FreeBSD 下会立即返回 writable。

事实证明，还是需要如下检查的：

```C++
static bool IsConnectingOK(int fd)
{
    int error = 0;
    unsigned int sz = sizeof(error);
    int code = getsockopt(fd, SOL_SOCKET, SO_ERROR, (void *)&error, &sz);
    return !((code < 0) || error);
}
```

[http://blog.yufeng.info/archives/565][1]

[1]:http://blog.yufeng.info/archives/565
