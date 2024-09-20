# Working with SVN

写了不少svn的心得，汇总一下，备查。


## 初涉江湖

剑法初成，一招一式，依样画葫芦。

从user guide中学习基础，学会简单的update、commit、merge。

blogbus估计不给我保存很早之前的文章了，最早的三篇，失联了~ :-(

* 失联：[work copy更新后那些symbol的含义 (U/A/D/R)][1]
* 失联：[Branching & Merging - Common Use-Cases][2]
* 失联：[Common Branching Patterns - Release Branches][3]
* [Branch Maintenance][4]
* [HEAD/BASE/COMMITTED/PREV之间的dusty关系][5]
* [奇怪的changeset][6]
* [SVN move 中的 policy][7]


## 行侠仗义

剑法纯熟，大开大阖，每式之精要，了然于胸。

根据实际的项目，管理svn仓库，学习高级用法。

* [自己建立 svn 仓库][8]
* [配置文件的所在地][9]
* [svn:externals 属性][10]
* [svn:eol-style / svn:keywords][11]
* [set property - do it automatically][12]
* [自动 commit 通知 -- mailer.conf][13]


## 浪迹天涯

不拘泥于形式，见招拆招，随心而发。

运起google大法，解决各种问题。

* [编码问题引来的 Malformed URL][14]
* [SVN"未授权打开根进行编辑操作"的bug][15] 
* [原来 svnserve 比 apache mod_dav_svn 快很多][16]
* [Could not read status line: connection was closed by server][17]
* [working copy 某个目录太大，不希望 update 到][18]  


[1]:http://kstack.blogbus.com/logs/3052129.html
[2]:http://kstack.blogbus.com/logs/3062536.html
[3]:http://kstack.blogbus.com/logs/3062897.html
[4]:https://github.com/kasicass/blog/blob/master/scm-svn/2014_09_05_branch_maintenance.md
[5]:https://github.com/kasicass/blog/blob/master/scm-svn/2014_09_05_HEAD_BASE_COMMITTED.md
[6]:https://github.com/kasicass/blog/blob/master/scm-svn/2014_09_05_about_changeset.md
[7]:https://github.com/kasicass/blog/blob/master/scm-svn/2006_09_19_svn_move.md
[8]:https://github.com/kasicass/blog/blob/master/scm-svn/2006_11_01_svn_repo_hosting.md
[9]:https://github.com/kasicass/blog/blob/master/scm-svn/2006_11_06_where_is_svn_conf.md
[10]:https://github.com/kasicass/blog/blob/master/scm-svn/2008_04_10_svn_externals.md
[11]:https://github.com/kasicass/blog/blob/master/scm-svn/2008_04_21_eolstyle_and_keywords.md
[12]:https://github.com/kasicass/blog/blob/master/scm-svn/2008_04_21_auto_set_property.md
[13]:https://github.com/kasicass/blog/blob/master/scm-svn/2008_07_10_commit_auto_email.md
[14]:https://github.com/kasicass/blog/blob/master/scm-svn/2008_07_10_malformed_URL.md
[15]:https://github.com/kasicass/blog/blob/master/scm-svn/2009_10_01_cant_access_root.md
[16]:https://github.com/kasicass/blog/blob/master/scm-svn/2011_03_15_svnserve_is_faster.md
[17]:https://github.com/kasicass/blog/blob/master/scm-svn/2015_10_08_cant_read_status_line.md
[18]:https://github.com/kasicass/blog/blob/master/scm-svn/2017_09_13_ignore_some_dir.md
