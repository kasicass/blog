# package 的 add/remove

```shell
# 从一个 deb 文件安装
sudo dpkg -i package_name.deb

# 删除一个 pkg
sudo apt-get --purge remove package-name

# 察看 pkg
dpkg -l | grep 'string you are looking for'
```
