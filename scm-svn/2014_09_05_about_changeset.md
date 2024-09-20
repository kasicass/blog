# [SVN] 奇怪的changeset

老文章搬家：[http://www.blogbus.com/kstack-logs/3081031.html][1]

### Conversion

初始状态

```
[trunk]
  |
  |-- a.txt
```

下面是示例均使用如下repository layout。

```
               11         12         14
       /-------|----------|----------|-------- /branches/one_branch
      /      A b.txt    M b.txt     D a.txt 
     /
    /             13            
---|--------------|------------------------- trunk
   10           M a.txt      
```

### Ugly problems

在上面所示的状态下，我们分别进行下面的操作，结果是什么？

PS. 为了方便，假设所有东西均处于 / 下面

1. svn merge -r 10:HEAD /branches/one_branch /trunk
2. svn merge -r 10:HEAD /trunk /branches/one_branch
3. svn merge -r 11:12 /branches/one_branch /trunk

### SVN：“我们只在乎change”

1. 'trunk' 中会加入b.txt文件，并删除a.txt文件。问题，r13中对a.txt的修改没了。。。
2. 因 “Can't find target: b.txt” 而失败
3. 同上 :_) ...

因为merge仅仅是对changes的一种重复，把'one_brance'中revision A - revision B之间所做的changes，放到'trunk'中再做一遍。因此，正如<1>，SVN并不会在乎'trunk'中a.txt是否改动过。而<2><3>中，如果没有target，就不能重复changes，而merge过程失败。

### 说说 svn cp

我们在 svn cp 的时候，习惯用 wcpath 来操作，而少用 url，因为wcpath方便嘛，可以少typing些字符。

问题来了，假设我们在 svn cp 前对 a.txt 进行了修改（还未commit），而我们产生的 'one_branch' 并不需要此类的修改。如果此时用 wcpath 来做 svn cp，就会出问题了。

此时

```
svn cp /trunk /branches/svn_cp_wc
```

和

```
svn cp http://.../trunk /branches/svn_cp_url
```

得到的结果是不同的。

此时'svn_cp_wc'中的a.txt是改动过后的，而'svn_cp_url'中的a.txt则是 r HEAD 下的 a.txt。

## 总结

原先对SVN的changeset的概念并不是很了解，经过上面的思考，对其有了比较深的感受。

理解不一定正确，欢迎讨论。


[1]:http://www.blogbus.com/kstack-logs/3081031.html
