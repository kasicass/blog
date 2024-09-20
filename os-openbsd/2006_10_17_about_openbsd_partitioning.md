# Partitioning --- 小肥鱼分区之讨论

我喜欢 unix 是因为它的很多内容都是很统一的，包括对硬盘的分区。这里讨论对 OpenBSD 的分区，其实对所有的 unix 都可以使用类似的硬盘分区。

对于 OpenBSD，我们一般分出一下几个区：

### /

The root partition holds the main system configuration files and the most essential UNIX utilities needed to get a computer into single-user mode.

基于上面的原因，我们一般将第一个分区设为 root分区。大小一般为 500M 为适，最小不应该低于 50M。为什么是 500M 呢，因为老机器有很多限制，《Absolute OpenBSD》中如下解释：

```
Root Limitations
Over the years, i386 systems have been expanded time and time again to surpass their own limits. They're based upon an architecture that could originally handle a maximum of 640KB of RAM, after all! The OpenBSD kernel — indeed, all modern operating system kernels — work around these limits in a manner mostly transparent to the user, but when the system is first booting you're trapped with the BIOS limitations.

Many old i386 systems have a 504MB limit on hard drives, on which the BIOS cannot get at anything beyond the first 504MB of data on a disk. If your BIOS cannot find your operating system kernel in that first 504MB, it cannot boot the system. Check your hardware manual; if it makes any references to a 504MB limit, this affects you. You absolutely must place your entire root partition within the first 504MB of disk.

Additionally, for some time i386 systems had a similar (not identical) 8GB limit. OpenBSD still obeys that 8GB limit. Even if your system is not susceptible to the 504MB limit, your entire root partition must be completely contained within the first 8GB of disk.
```

因此，我们遵循 500M 这个标准就好。

### /swap

the disk space used by virtual memory.

我们的交换分区啦，Windows 是用一个文件作为 swap 的，而 unix 们多是使用独立的 swap分区。一般 swap分区 大小是两倍的 RAM 比较合适。对于多个硬盘，可以将 swap分区 分别放到不同的硬盘上，这样更有效率，因为“硬盘间数据读写”比“一个硬盘内读写”要慢许多。而且 swap分区 应该尽量靠前，因为分区越靠前，访问速度越快。

### /tmp

The /tmp directory is system-wide temporary space.

一般 500M 即可。

### /var

The /var partition contains frequently changing logs, mail spools, temporary run files, the default website, and so on.

如果机器是 web server，则 /var 应该至少要 1G。var分区 最少为 30M。

### /usr

The /usr partition holds the operating system programs, system source code, compilers and libraries, and other little details like that.

这里就类似 Windows 的 Program Files，随着应用程序不断增加，占用的空间将不断增大。因此，尽量分配大一些的空间。最少也要分配 200M（不使用 X Window 的情况）or 350M（使用 X Window）

### /home

The /home partition is where users keep their files.

如果个人文件很多，也会占用很多空间，这个分区给大一点。

PS. 对于有多硬盘的情况，如果是 Web server，第二个硬盘可用于 /www 或 /home；如果是 mail server，第二个硬盘可用于 /var 或 /var/mail；如果是 network logging host，则可用于 /var/log。