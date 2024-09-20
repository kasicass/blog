# [pthread] 关于函数返回值

今天认真看了下 pthread mutex 的 man page 才发现此问题。对于一般的 *nix API

 * 成功返回0
 * 失败返回-1，并设置 errno
  
而 pthread 的这堆 API 是

 * 成功返回 0
 * 失败返回 err_code，而 err_code (EAGAIN, EINVAL等等) 一般定义都是 > 0 的整数。

传统的 *nix API，我们习惯上：

```C
if ( (fd = open("filename", O_CREAT|O_RDWR)) < 0 )
    // error
```

而 pthread 这堆 API ，错误检查应该这样写：

```C
if ( pthread_create(&pid, NULL, mythr, NULL) != 0 )
    // error
```

感叹下~~ 习惯的力量真可怕。- -#
