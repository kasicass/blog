# [SVN] HEAD/BASE/COMMITTED/PREV之间的dusty关系

老文章搬家：[http://www.blogbus.com/kstack-logs/3080410.html][1]

### 概念

```
HEAD      - The lastest revision in the repository.
BASE      - The "pristine" revision of an item in a working copy.
COMMITTED - The last revision in which an item changed before (or at) BASE.
PREV      - The revision just before the last revision in which an item changed. (Technically, COMMITTED - 1.)
```

* HEAD - 目前repository上最新的revision，也许个人在操作wc的时候，有其他的成员commit成果，那么HEAD会变化的。
* BASE - 对于一个item，BASE指我们check out的那个revision。
* COMMITTED - 其必然 <= BASE，对于一个item，COMMITTED是最后修改时的那个revision。
* PREV - (COMMITTED - 1)

上面的解释看不明白就是正常，请继续阅读……


### 从item & revision引发的讨论

item，就是SVN中被管理的东东（包括folder、file）。而每次commit都会产生一个snapshot，并记录一个revision。对于revision，it's not valid to talk about “revision 5 of foo.c”. Instead, one would say “foo.c as it appears in revision 5”.

例如：有文件 foo.c、bar.c

```
     13          17               24          25           26
-----|----...----|-------...------|-----------|------------|--------- trunk
  M foo.c      M foo.c          M bar.c     M bar.c       others ...
```

我们在r24之前，都没有对bar.c进行改动，因此，bar.c在 1 ~ 23 里面的内容是一样的。而在r24, r25，foo.c 的内容与其在 r23 的时候没有区别。

这时，我们check out [trunk@24]。并在trunk目录下

```
svn st -v
```

则可以看到

```
BASE  COMMITTED
24    24           . 
24    17           foo.c
24    24           bar.c
```

其中foo.c与bar.c的COMMITTED是不一样的。

这时，我们进行r25的行为，修改了bar.c，并commit了。并

```
svn st -v
```

可以看到

```
BASE  COMMITTED
24    24           .
24    17           foo.c
25    25           bar.c
```

这说明了此时bar.c的变化情况。为何foo.c的BASE还是24呢？因为此时的foo.c是r24那时的foo.c。ok，我们

```
svn up
svn st -v
```

可以看到

```
BASE  COMMITTED
25    25           .
25    17           foo.c
25    25           bar.c
```

Yeah~，一切ok。

说完了最麻烦的BASE和COMMITTED。

PREV没什么好说的。而HEAD，如果r26为最后一个提交到repository的改动，那么r26就是HEAD罗～


## 总结

感谢阅读到这里，打字很辛苦。来，给点掌声。:o)

这里的理解不一定正确，欢迎讨论。


[1]:http://www.blogbus.com/kstack-logs/3080410.html
