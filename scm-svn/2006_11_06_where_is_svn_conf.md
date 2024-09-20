# [SVN] 配置文件的所在地

 SVN 的配置文件有两种类型
 
  * site-wide，表示对于整个机器所有用户的通用配置
  * per-user，对于每个用户的特别设置。

与其他的 unix 工具类似，优先加载 per-user，然后到 site-wide。

对于当前用户，如果希望恢复 per-user 的默认设置，可以删除 ~/.subversion 目录，然后 svn --version 就会自动创建默认的配置文件了。

下面是配置文件的所在：

site-wide

```
  Unix:
    /etc/subversion/servers
    /etc/subversion/config
    /etc/subversion/hairstyles
  Windows:
    %ALLUSERSPROFILE%\Application Data\Subversion\servers
    %ALLUSERSPROFILE%\Application Data\Subversion\config
    %ALLUSERSPROFILE%\Application Data\Subversion\hairstyles
    REGISTRY:HKLM\Software\Tigris.org\Subversion\Servers
    REGISTRY:HKLM\Software\Tigris.org\Subversion\Config
    REGISTRY:HKLM\Software\Tigris.org\Subversion\Hairstyles
```

per-user

```
  Unix:
    ~/.subversion/servers
    ~/.subversion/config
    ~/.subversion/hairstyles
  Windows:
    %APPDATA%\Subversion\servers
    %APPDATA%\Subversion\config
    %APPDATA%\Subversion\hairstyles
    REGISTRY:HKCU\Software\Tigris.org\Subversion\Servers
    REGISTRY:HKCU\Software\Tigris.org\Subversion\Config
    REGISTRY:HKCU\Software\Tigris.org\Subversion\Hairstyles
```

PS

* HKLM for HKEY_LOCAL_MACHINE
* HKCU for HKEY_CURRENT_USER
