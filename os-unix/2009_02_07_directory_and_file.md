# [shell] 目录/文件常用判断

```Shell
#!/bin/sh

myPath="/var/log/httpd/"
myFile="/var/log/httpd/access.log"

# -x 判断 $myPath 是否存在，且是否具有可执行权限
if [ ! -x "$myPath" ]; then
  mkdir "$myPath"
fi

# -d 判断 $myPath 是否为目录
if [ ! -d "$myPath" ]; then
  mkdir "$myPath"
fi

# -f 判断 $myFile 是否为文件
if [ ! -f "$myFile" ]; then
  touch "myFile"
fi

# -n 判断一个变量是否不为空
if [ ! -n "$myVar" ]; then
  echo "$myVar is empty"
  exit 0
fi

# 判断两个变量是否相等
if [ "$var1" = "$var2" ]; then
  echo '$var1 eq $var2'
else
  echo '$var1 not eq $var2'
fi
```