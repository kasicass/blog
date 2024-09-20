# [OpenBSD] 安装 java

因为 lisence 的原因，在 BSD 上安装 JDK 是个麻烦的事情。

/usr/ports/devel/jdk/1.5

```
<1> 同意 JRL
# cat /etc/mk.conf                                                             
ACCEPT_JRL_LICENSE=Yes

<2> 下载到 /usr/ports/distfiles
jdk-1_5_0_14-fcs-src-b03-jrl-05_oct_2007.jar
jdk-1_5_0_14-fcs-bin-b03-jrl-05_oct_2007.jar
http://download.java.net/tiger/tiger_u14/jdk-1_5_0_14-fcs-src-b03-jrl-05_oct_2007.jar
http://download.java.net/tiger/tiger_u14/jdk-1_5_0_14-fcs-bin-b03-jrl-05_oct_2007.jar

bsd-jdk15-patches-9.tar.bz2
http://www.eyesbeyond.com/freebsddom/java/jdk15.html
修改 Makefile，使用 -9.tar.bz2 patchset
md5 -b bsd-jdk15-patches-9.tar.bz2, 把MD5值写到 /usr/ports/devel/jdk/1.5/dist/distinfo

jdk-1_5_0_14-solaris-i586.tar.Z
http://java.sun.com/products/archive/j2se/5.0_14/index.html

xalan-j_2_7_0-bin.tar.gz，居然需要断点续传，使用 ftp or firefox 都不行，要用 wget
http://archive.apache.org/dist/xml/xalan-j/xalan-j_2_7_0-bin.tar.gz

<3> make install

<4> 配置运行环境
$ vi .profile
PATH=...:/usr/local/jdk-1.5.0/bin
export PATH
export JAVA_HOME=/usr/local/jre-1.5.0
export CLASSPATH=:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
注意 CLASSPATH=:... 这第一个 :，表示把当前目录作为第一个 classpath，否则就会碰到如下错误。
$ java HelloWorld         
Exception in thread "main" java.lang.NoClassDefFoundError: HelloWorld
```
