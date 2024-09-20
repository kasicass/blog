# [OpenBSD] 使用U盘

将U盘插入，看看 dmesg | tail，会有下面类似的信息。

```
umass1 detached
umass1 at uhub0 port 5 configuration 1 interface 0 "Kingston DataTraveler 2.0" rev 2.00/1.00 addr 3
umass1: using SCSI over Bulk-Only
scsibus3 at umass1: 2 targets, initiator 0
sd2 at scsibus3 targ 1 lun 0: <Kingston, DataTraveler 2.0, 1.00> SCSI2 0/direct removable
sd2: 1906MB, 243 cyl, 255 head, 63 sec, 512 bytes/sec, 3905407 sec total
```

其中，umass1 是 usb disk storage 的 driver。

注意看 sd2 那个，说明 /dev/sd2i 是对应的U盘的 device。只需：

```
mount_msdos /dev/sd2i /mnt/usb
```

即可。

参考：

[https://www.cyberciti.biz/faq/openbsd-mounting-usb-flash-drive-harddisk/][1]

[1]:https://www.cyberciti.biz/faq/openbsd-mounting-usb-flash-drive-harddisk/
