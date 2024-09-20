# PostgreSQL 16.4 on OpenBSD 7.5: Install

《[PostgreSQL 14.5 on OpenBSD 7.2: Install][1]》文章太赞了，直接复制过来。


## Summary

因为 [miniflux][2] 的需要，在 OpenBSD 7.5 上安装 PostgreSQL 16.4。


### Environment

* OS: OpenBSD 7.5
* Database: PostgreSQL 16.4


### Overview

Each step is described later.

```
$ doas pkg_add postgresql-server

$ doas su - _postgresql

$ # --locale below is optional
$ # the password of "postgres" below, the superuser, will be asked 
$ initdb -D /var/postgresql/data -U postgres \
      -W -A scram-sha-256 -E UTF-8 --locale=xx_XX.UTF-8

$ exit

$ doas rcctl enable postgresql
$ doas rcctl start postgresql
```


## Tutorial

The one-by-one steps are as follows.


### 1. Install PostgreSQL Server

Get the package to be installed from [package system][3]:

```
$ doas pkg_add postgresql-server
```

The output was:

```
postgresql-server-16.4:postgresql-client-16.4: ok
useradd: Warning: home directory `/var/postgresql' doesn't exist, and -m was not specified
postgresql-server-16.4: ok
The following new rcscripts were installed: /etc/rc.d/postgresql
See rcctl(8) for details.
New and changed readme(s):
	/usr/local/share/doc/pkg-readmes/postgresql-server
```


### 2. Init database

In order to avoid permissions error, switch user to **_postgresql** which was created above:

```
$ doas su - _postgresql
```

Run **init_db** to create a database cluster. Well, **/var/postgresql** directory will be created automatically:

```
$ initdb -D /var/postgresql/data -U postgres \
      -W -A scram-sha-256 -E UTF-8 --locale=xx_XX.UTF-8
```

**-U postgres** (= **--user=...**) above is the superuser's name.

The output started with:

```
The files belonging to this database system will be owned by user "_postgresql".
This user must also own the server process.
```

Then, when **-W** (= **--pwprompt**) is set, password will be asked. **-W** and **-A scram-sha-256** (= **--auth=...**) are for the sake of security.

As a reference, the documentation (**/usr/local/share/doc/pkg-readmes/postgresql-server**) says:

```
It is strongly advised that you do not work with the postgres dba account other than creating more users and/or databases or for administrative tasks. Use the PostgreSQL permission system to make sure that a database is only accessed by programs/users that have the right to do so.
```

Well, **--locale=...** is optional for one but en_US.UTF-8.

Enter the password:

```
Enter new superuser password: 
Enter it again: 
```

The rest was:

```
fixing permissions on existing directory /var/postgresql/data ... ok
creating subdirectories ... ok
selecting dynamic shared memory implementation ... posix
selecting default max_connections ... 20
selecting default shared_buffers ... 128MB
selecting default time zone ... Asia/Shanghai
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok

Success. You can now start the database server using:

    pg_ctl -D /var/postgresql/data -l logfile start
```

Yay, successful. Let's **exit** from **_postgersql** user:

```
$ exit
```


### 3. Start PostgreSQL server

Activate the daemon and start it:

```
$ doas rcctl enable postgresql
$ doas rcctl start postgresql
postgresql(ok)
```


### 4. Work with the server

The postgresql server daemon is now activated and started. It works as RDBMS and listens to requests from clients.

The configuration files such as **postgresql.conf** and **pg_hba.conf** were generated automatically, and also [psql][4] was installed.


#### Configuration files

They are useful to configure the server.


#### psql

It is used as a terminal-based front-end to PostgreSQL. By using the password asked above, it's able to connect to the server:

```
$ psql -U postgres
Password for user postgres:
```

You will be welcomed :)

```
psql (14.5)
Type "help" for help.

postgres=#
```



[1]:https://obsd.solutions/en/blog/2022/11/13/postgresql-145-on-openbsd-72-install/
[2]:https://miniflux.app/
[3]:https://www.openbsd.org/faq/faq15.html
[4]:https://www.postgresql.org/docs/current/static/app-psql.html
[5]:https://www.postgresql.org/docs/current/runtime-config.html
