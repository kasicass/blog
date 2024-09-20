# 配置 NAT 和 Bridged Network

## NAT 结构

```
                  Internet
                     |
                    Host
                     |
   |------------------------|-------------- ....
VMachine1                VMachine2

Host, 192.168.0.76
VMachine1, 10.0.2.15
VMachine2, 10.0.2.16
gateway, 10.0.2.2
dns, 10.0.2.3               # 要使用 -natdnshostresolver1 on，才能正常工作

NAT 不方便从外部访问 VMachine，只能做 port forwarding。比如下面想实现 ssh 登陆 VMachine。

从 127.0.0.1:2222 来的所有包，发送到 10.0.2.16:22 上。
VBoxManage modifyvm "VM name" --natpf1 "guestssh,tcp,127.0.0.1,2222,10.0.2.16,22"

删除 guestssh 这个 forwarding 设定。
VBoxManage modifyvm "VM name" --natpf1 delete "guestssh"

查看 vm 有几个 forwarding （还包括一些其他信息）
VBoxManage showvminfo "VM name" --machinereadable

让 VMachine 使用 Host 的 DNS 来解析域名。
VBoxManage modifyvm "VM name" --natdnshostresolver1 on

但是，vm1 和 vm2 之间是无法访问的，因为每个独立的 vm 都是一个独立的 NAT。
```
## Bridged Network

```
VMachine 相当于与 host 处于同一网络。
                           Internet
                              |
   |---------------|-------------------|----------- ...
Host            VMachine1           VMachine2

Host, 192.168.0.76
VMachine1, 192.168.0.15
VMachine2, 192.168.0.16
```
