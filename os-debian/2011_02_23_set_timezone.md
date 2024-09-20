# 设置时区

dpkg-reconfigure tzdata

通过 ntp 调整系统时间

```
# aptitude install ntpdate
# ntpdate pool.ntp.org
```