# OpenBSD httpd + PHP: a file upload html

works on OpenBSD 7.8

百度网盘网页版，下载大于50M的文件，非得下载客户端。无奈OpenBSD下没有它的客户端。

那，曲线救国，先从手机下载文件，再把文件上传到我的OpenBSD笔记本上。


## 技术选型

* [httpd][1] - OpenBSD自带的httpd
* [php][2] - 一点小尝试

安装PHP

```
# pkg_add php-8.4.20
```


## Round 1 - http/php works


### 启动httpd

httpd的根目录在/var/www，httpd通过chroot切换到/var/www，所以httpd.conf中的目录，是基于/var/www的。

编辑/etc/httpd.conf

```
types {
  include "/usr/share/misc/mime.types"
}

server "default" {
  listen on * port 80

  root "/htdocs"
  directory index index.php

  location "*.php" {
    fastcgi socket "/run/php-fpm.sock"
  }
}
```

httpd和php_fpm通过fastcgi通讯。/run/php-fpm.sock 实际对应 /var/www/run/php-fpm.sock

启动服务

```
# rcctl enable httpd
# rcctl start httpd
```

配置一个简单的网页

```
# cd /var/www/htdocs
# echo "httpd runs~" > a.html
```

* 打开网页：http://localhost/a.html
* 看能否正常访问


### 启动php84_fpm

添加基础配置

```shell
# cp /etc/php-8.4.sample/* /etc/php-8.4
```

启动服务

```
# rcctl enable php84_fpm
# rcctl start php84_fpm
```

生成测试网页

```
# cd /var/www/htdocs
# echo "<?php phpinfo(); ?>" > index.html
```

* 打开网页：http://localhost/
* 测试php是否工作


## Round 2 - a simple file upload html

* 一个简单页面，只有一个Upload按钮
* 将文件保存到/var/www/htdocs/uploads目录
* /var/www/htdocs/b.php

创建uploads目录

```
# cd /var/www/htdocs
# mkdir uploads
# chown www:www uploads
# chmod 755 uploads
```

b.php的内容

```php
<?php
$upload_dir = 'uploads/';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['file'])) {
  $file = $_FILES['file'];
  if ($file['error'] === UPLOAD_ERR_OK) {
    $name = preg_replace('/[^a-zA-Z0-9_.-]/', '', $file['name']);
    move_uploaded_file($file['tmp_name'], $upload_dir . ($name ?: uniqid()));
    echo 'OK';
  } else {
    echo 'ERROR';
  }
  exit;
}
?>

<form method=POST enctype=multipart/form-data>
<input type=file name=file onchange="this.form.submit()" style=display:none id=f>
<button type=button onclick="f.click()">Upload</button>
</form>
```

* 一切就绪。访问：http://localhost/b.php
* 上传～
* 但，居然提示"413 payload too large"


## Round 3 - fix 413 error

我上传的文件80M，超过了默认配置。

修改httpd.conf

```
server "default" {
  # 100M
  connection max request body 104857600
}
```

修改/etc/php-8.4.ini

```ini
; listen on * port 80
ad_max_filesize = 100M

; POST 数据最大大小（必须 >= upload_max_filesize）
post_max_size = 100M

; 内存限制（建议大于100M）
memory_limit = 256M

; 最大执行时间（秒），上传大文件需要更长时间
max_execution_time = 600

; 请求最大等待时间
max_input_time = 600
```

重启服务

```
# httpd -n                  # <-- 检查httpd.conf的正确性
configuration OK

# rcctl restart httpd
# rcctl restart php84_fpm
```

搞定！全程deepseek指导，丝滑解决问题。


[1]:https://man.openbsd.org/httpd
[2]:https://www.php.net/

