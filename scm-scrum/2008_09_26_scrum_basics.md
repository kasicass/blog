# 关于 Scrum 各个阶段的琐碎记录


最近在看Ken Schwaber的《[Agile Software Development with Scrum][1]》，多多少少有些感悟，记之。

## The Scrum Master

职责：下决定；控制需求；扫除障碍

维系需求方与开发者的纽带，全程参与所有的过程，了解进度的情况，控制需求的不正常增加。
此职位需要很高的开发能力，同时又能根据项目的情况，定知合理的Backlog, sprint的机制。

## Product Backlog

需求列表，开发过程中不断修正之。

内容包括：
 * 市场的需求（市场活动）
 * 策划的需求（开发内容）
 * 美术的需求（改进工具）
 * 程序的需求（改进/优化程序结构）
 * 运维的需求（改进数据中心，gmtool）

## Scrum Team

组成6 - 8人

 1. 包括 coder & tester
 2. 完成 sprint 所需要的成员
 3. 最好组内有一名非常有经验的 coder

国外行业的发展比较久，因此3.的条件比较容易达到。许多开发方法论，都要求在技术不是主因的情况下，才能成为可能，国内的情况就差远了。优秀的coder都不好找啊~

## Daily Scrum Meeting

三个问题：

 * 昨天完成了什么
 * 今天打算做啥
 * 遇到什么困难 or 有啥心得

每日的 meeting，简洁、高效，对遇到的问题，leader 快速做出决定（扫除障碍）。

## Sprint Planing Meeting

sprint 开始前的一个讨论会，从 Backlog 中选取优先级高的任务，然后 team member 评估任务完成要花费的时间，最后确定此次 sprint 要完成哪些任务。

## Sprint

每月一次的冲刺式开发，要求结束时有 product release。

对于 scrum team，要求管理者给与他们足够的自由，让 team member 自发的在 sprint 中成长，同时了解每个人的能力。

对于 sprint 目标中，技术上的不确定因素，也让他们自由去寻找解决方案。即使本次 sprint 失败了，对于 team member 来说也是很大的锻炼。

对于进度，要求管理者自己去旁听 daily meeting，自己作记录，而不是让 team 给管理者汇报。
一个 team 没有计划和管理，肯定是不行的。sprint 则是下放权力，让 team 形成自己的开发方式。

其实这也要求 team 中有经验丰富的成员，才能更快的完成成长过程。scrum 的整个过程，对 Scrum Master 的要求是很高的。

## Sprint Review

本次冲刺开发的回顾。

## 附篇

影响项目的几个因素（程序员角度）

 * 程序员本身的能力、经验
 * 开发流程的好坏（与策划/美术的沟通配合）
 * 开发团队的氛围、成员的工作态度


[1]:https://www.amazon.com/Agile-Software-Development-Scrum/dp/0130676349/
