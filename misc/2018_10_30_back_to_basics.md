# Back to Basics

KISS - Keep It Simple and Stupid

## About Build-System I

我们在项目中，会碰到各种 build-system。其实很多时候，build-system is overkill。与其花时间在学习各种 build-system 上，不如熟悉好编译器参数，写个最简单的 .bat/Makefile 就可以搞定了。

看看 build-system bigbang!

C/C++

* [gmake][3]
* [nmake][12]
* [emake][9]
* [cmake][4]
* [fastbuild][5]
* [msbuild][6]

Java

* [ant][1]
* [maven][2]

Others

* [pantsbuild][7]

fastbuild 是给超大型 C++ 项目（几百万行 C++ 代码）的项目用来做并行编译的。

pantsbuild 是给超大型混搭语言的项目用的。

工作中我主要用 C/C++/Python，对于 build-system，有一套固定的组合。

* CMake，大型 C++ 项目
* Makefile/emake，中小型 C/C++ 项目

## About Build-System II

有段时间 fmod 有个 bug，需要改改源码，build 一个新版 .lib 出来。但 fmod 自带的 vc 工程已经很老了。想 build 出来，要得做升级，改配置。

我又想是不是用 cmake 改造一下 fmod 的工程，方便以后适配新的 vc 版本。失败了：

1. fmod 有一些汇编代码，需要 nasm 编译。cmake 编译汇编有点麻烦
2. 对 cmake 不熟，折腾了半天

当时正好在看 [handmadehero][10]，作者 [第一章][11] 就推荐不要用 build-system。自己写 .bat 即可。灵感突来，最后改用 .bat，花了十几分钟，搞定。

```bat
@echo off

set Fmod4Dir=..\..\fmod4

set CompilerFlags=/nologo /Od /MTd /Zi /c
set CompilerFlags=/DDEBUG /D_DEBUG /DWIN32 %CompilerFlags%
set CompilerFlags=/I%Fmod4Dir%\src %CompilerFlags%

set LibFlags=/NOLOGO /OUT:"..\fmod_event.lib"

IF NOT EXIST ..\build\fmod_event mkdir ..\build\fmod_event
pushd ..\build\fmod_event

:: compile files
cl %CompilerFlags% %Fmod4Dir%\tools\fmod_event\src\fmod_buckethash.cpp
set ObjFiles=fmod_buckethash.obj

:: ...

:: make .lib
lib %LibFlags% %ObjFiles%

popd
```

寻找最合适的方式去解决问题，不要在外围事情上花费太多时间。

## About Blog

之前的 blog 在 163 上。最近要关闭了。

* [http://kasicass.blog.163.com/][13]

准备把 blog 搬家到 github，一直在研究 static site generator。却没选到足够简单的。

* [pelican][14]，python 的，我喜欢，但用起来有点复杂。
* [hexo][15]，这货最出名，但我不用 node.js
* [hugo][16]，最近go很火，hugo也不错

我不过是要一个 blog，搞这么多 generator 干啥。需求：

* 用来写自己的学习心得 (markdown is good enough)
* 能有网页，方便查看

最后，自己设计一个最简单的方法。

* /blog，写 .md
* /kasicass.github.io，写个 python 小程序，生成 index.html，索引 /blog 中的 .md

新 blog，在 [这里][17]。

## About Tech Learning

做技术的，总会说："技术变革太快了，每天都再不停地学习。"。诚然。

拿互联网来说。从早年的 web server & middleware

* [apache httpd][18]
* [nginx][19]
* [redis][20] 
* [kafka][21]
* [dubbo][22]

到现在很火的，大数据 & 容器

* [zookeeper][27]
* [hadoop][23]
* [spark][24]
* [k8s][25]
* [etcd][26]
* [docker][29]

然后到，人工智能

* [tensorflow][28]

What's the fuck~ 这么多东西，怎么学得完？

先说个故事。

```
大学时期，听过 IBM 的讲座，介绍 WebSphere 的。现场讲解如何用
SOAP 来封装一个 WebService，演示如何做一个 add(a, b)函数，把
两个数加起来。讲解员费了九牛二虎之力，终于把 1 + 1 = 2 跑起来了。

十多年过去，WebSphere 在哪里？

对于工作业务中不接触 SOAP 的 coder，SOAP 与你何干？
```

做了多年技术之后，自己要学会分辨哪些该学，哪些只是过眼云烟。

* 对于工作业务相关的，需要很好的掌握。
* 找一些自己感兴趣的，和业务比较相关的技术研究下。
* 熟悉应用开发下面一个层次的内容，比如：Operating System

## About My Tech Stack

游戏服务端技术栈

* C/golang/python
* C++ (optional)
* Operating System
* Database
* HTTP
* TCP/IP

对于 C/C++ 服务端程序员来说，golang 是最佳的升级选项。

C++ 是一门开发效率很低，脑力消耗很大的语言，能不用的时候，尽量不用。

做 high-performance 调教的时候，Operating System 是绕不开的话题。越熟悉越好。

* linker and loader
* process and thread
* dtrace/systemtap

数据库，掌握好业务中用到的即可。

* [mongodb][30]
* [mysql][31] / [mariadb][32]

HTTP/TCP/IP 是写应用程序需要接触到的，最常用的协议栈。多熟悉熟悉，有好处。

## About 公众号排版

将 Markdown 转换为 富文本，然后贴到公众号平台即可。

 * [http://md.aclickall.com/][33]
 * [https://blog.csdn.net/gary_yan/article/details/79005262][34]


[1]:http://ant.apache.org/
[2]:http://maven.apache.org/
[3]:https://www.gnu.org/software/make/
[4]:https://cmake.org/
[5]:www.fastbuild.org/
[6]:https://github.com/Microsoft/msbuild
[7]:https://www.pantsbuild.org/
[8]:https://www.jianshu.com/p/b09125018c04
[9]:https://github.com/skywind3000/emake
[10]:https://handmadehero.org/
[11]:https://hero.handmade.network/episode/code/day001/
[12]:https://docs.microsoft.com/en-us/cpp/build/nmake-reference?view=vs-2017
[13]:http://kasicass.blog.163.com/
[14]:https://blog.getpelican.com/
[15]:https://hexo.io/
[16]:https://gohugo.io/
[17]:https://kasicass.github.io/
[18]:https://httpd.apache.org/
[19]:https://nginx.org/en/
[20]:https://redis.io/
[21]:http://kafka.apache.org/
[22]:http://dubbo.apache.org/en-us/
[23]:https://hadoop.apache.org/
[24]:https://spark.apache.org/
[25]:https://kubernetes.io/
[26]:https://coreos.com/etcd/
[27]:https://zookeeper.apache.org/
[28]:https://www.tensorflow.org
[29]:https://www.docker.com/
[30]:https://www.mongodb.com/
[31]:https://www.mysql.com/
[32]:https://mariadb.org/
[33]:http://md.aclickall.com/
[34]:https://blog.csdn.net/gary_yan/article/details/79005262
