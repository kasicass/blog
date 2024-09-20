[SVN] working copy 某个目录太大，不希望 update 到

```
project/
project/dirA
project/dirB
project/dirLarge

> cd project/
> svn up --set-depth exclude dirLarge
D dirLarge
```

以后更新 svn up project/ 就不会再更新到 dirLarge 了。
