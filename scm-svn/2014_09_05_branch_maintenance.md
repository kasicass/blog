# [SVN] Branch Maintenance

老文章搬家：[http://www.blogbus.com/kstack-logs/3067304.html][1]

### Branch Layout

对于Branch，对于多数的project，均可以有一个统一的repository layout（仓库结构），如下：

```
/trunk
/branches
/tags
```

以上三个目录基本上是一个project必不可少的几个folder。其中trunk是主干，branch为可能的branch，而tag就是release-1.0 ... stable-x.x放的地方了。（PS：tag其实和一个branch没有什么实际意义上的不同，仅仅是我们概念上的区分）

### Data lifetimes

对于branch，一旦其失去maintain的必要，就应该svn delete掉。若什么时候需要已经删除的branch，重新svn copy一下即可。。


[1]:http://www.blogbus.com/kstack-logs/3067304.html
