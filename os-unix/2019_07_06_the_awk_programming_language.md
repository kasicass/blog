# The AWK Programming Language

 * TODO
 * [https://github.com/wuzhouhui/awk][1]

## 关联数组

```
假设 logfile 就是一堆 ip
1.2.3.4
2.3.1.3
...

awk '{count[$1]++;} END{for (var in count) {print var" = "count[var]}' logfile
统计 ip 出现的次数。

if ("key" in map)         <--  要这样来判断 key 是否存在，不能写 if (map["key"] == "value") ...
```


[1]:[https://github.com/wuzhouhui/awk]