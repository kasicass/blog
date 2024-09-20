# [SVN] svn:externals 属性

虽然用了好一段时间 svn，但都没用过 external definition 的功能。svn:externals 属性就是让你可以在一个目录下，同时 checkout 不同路径的 svn path 下的内容。下面的具体的操作方法。

基本的目录结构。

```
[base]
  \- [one]
      \- a.txt
  \- [two]
      \- b.txt
```

之后

```
svn propedit svn:externals one
my_two  svn://.../base/two
```

然后 svn up 就可以看到

```
Fetching external item into 'my_two'
A    my_two/b.txt
```

目录结构变为：

```
[base]
  \- [one]
      \- a.txt
      \- [my_two]
          \- b.txt
  \- [two]
      \- b.txt
```

你不能用 svn propset 来设置此属性，而只能用 svn propedit。（大约是因为，svn:externals 是多行属性）
