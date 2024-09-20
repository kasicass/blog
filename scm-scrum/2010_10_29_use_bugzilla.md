# 用bugzilla来管理每周一次迭代的开发需求

游戏对外测试后，会慢慢走向每周一次的迭代开发，每周对外更新一次。

bugzilla没有trac的milestone功能，不太方便察看一周内的单子。每周增加一个component也不方便。
我选择一个简单的方法来处理此情况。

开发需求流程：

 1. 策划提出需求，提bugzilla单子
 2. 程序组长根据本周的工作两，把单子分配给对应的程序

比如对于 2010.07.20 放出的开发内容，单子标题为：

 * 2010.07.20: xxx

这样通过 2010.07.20 就可以search出所有本周要放出的单子。每周只需要修改下search的keyword即可。

不过bugzilla没有trac的timeline功能，可惜。

**Update 2018.11.11**

 * 后来，我司改用 [redmine][1]，milestone/timeline 功能都有了。
 * 无论使用 bugzilla 还是 trac、redmine，都需要二次开发，才能满足内部需求。

[1]:http://www.redmine.org/