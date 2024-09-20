# Using Cscope


## 官网

 * [http://cscope.sourceforge.net/][1]


## 创建索引

创建 cscope 索引文件

```
cscope -Rbkq
```

但 cscope 默认不扫描 .hpp / .cpp，可以这样：

```
$ cat ~/mytools/cscope_cpp.sh
#!/bin/sh

find . -name "*.h" -o -name "*.c" -o -name "*.cc" -o -name "*.hpp" -o -name "*.cpp" > cscope_cpp.files
cscope -bkq -i cscope_cpp.files
rm cscope_cpp.files
```

## vim中使用cscope

修改 ~/.vimrc

```
set csprg=/usr/bin/cscope
set cscopetag
cs add /path/to/cscope.out
```

 * set cscopetag，让 :tag 或 Ctrl + ] 默认使用 :cstag 命令，即 从cscope 索引中找 symbol。
 * cs add, 增加 cscope database 到 vim

vim 中 :help scope 可以看详细介绍。

[1]:http://cscope.sourceforge.net/
