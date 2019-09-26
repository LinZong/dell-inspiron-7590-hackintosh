## Dell Inspiron 7590 Hacktonish Guide

English version is being written, please wait for a few days.

This is a Chinese version.

**0x00 写在前面**

1. 配置

   机器配置为灵越7590次顶配, 非4K版本。

   CPU: i7 9750H

   RAM: 16GB DDR4

   SSD1: 原厂东芝BG4 512GB (Windows)

   SSD2: 海康威视C2000 (macOS)

   Graphic card: Intel UHD 630， NVIDIA Geforce GTX 1650（已屏蔽)

   WIFI: Intel Wireless AC 9560 (目前还没有换DW18)

   Bluetooth: WIFI芯片自带蓝牙，懒得查型号，Dell官方文档没给

   Sound card: Realtek ALC3254(与ALC 295相似, 在Windows下查看Hardware id报告为ALC295, 故本EFI按照ALC295的思路驱动)

2. 正常工作的功能

   CPU 正常变频

   正常睡眠, 正常关机重启

   Fn键正常调节音量

   声卡正常驱动（需要在系统安装完成后打补丁）

   显卡正常开启硬件加速

   HDMI正常输出

   读卡器正常

3. 不正常功能

   WIFI, 蓝牙无解

   独显无解，已屏蔽

   调节亮度的组合键不是Fn+F6 Fn+F7，而是Fn+S, Fn+B（尝试BRT6 to BRTX失败。暂时没有深究原因）

   机器自带麦克风失效

4. 待测试功能

   Thunderbolt3接口（只测试了充电，正常，手头没有雷电设备）

已测试系统版本: mojave 10.14.2 10.14.6

**0x01 如何使用**

本EFI基于[@xiaoMGithub](https://github.com/xiaoMGitHub/LEGION_Y7000Series_Hackintosh_Clover)的拯救者Y7000配置文件。为了表示对作者的感谢，笔者保留了此EFI的Clover Theme，如有需要可以自行更换。

本EFI不区分安装时引导和正常引导，你可以使用这个EFI安装/引导使用Mojave。使用方法与其他EFI一样，替换引导介质EFI分区中的EFI文件即可。详细的安装过程请参考其他macOS安装指南。

**0x02 修复耳机孔发声不正常**

当您使用此EFI完成macOS安装进入系统，不出意外的话整个系统看上去是正常的，但是此时将耳机插入耳机孔，会发现音乐听不到人声，只能听到背景音，就好像耳机没有完全插入耳机孔一样。如果您进入系统偏好设置->声音->输出，将平衡滑条调到最左或者最右，却能听到人声。

这是因为这块声卡本质上是一块ALC3254，它layout与正常的ALC295不尽相同，并且AppleALC中针对ALC295的Patch是based on Dell Latitude 5290的。

>[1.3.6](https://github.com/acidanthera/AppleALC/releases/tag/1.3.6)
>
>[![@vandroiy2013](https://avatars0.githubusercontent.com/u/8144780?s=40&v=4)](https://github.com/vandroiy2013) [vandroiy2013](https://github.com/vandroiy2013) released this on 21 Mar
>
> #### v1.3.6
>
>- Update Revision 0x100001 for CX20751/2 (Toshiba Kira 107)

>- Added ALC255 layout-id 15 for Gigabyte Brix BRi5(H), BRi7(H)] by najdanovicivan

>- Added **ALC295/ALC3254 for Dell Latitude 5290 by Unbelievable9**

>- Fix ALC1220 audio after sleep

>- Added ALC1220 layout-id 27 for Gigabyte-Z370-HD3P by lostwolf

>- Added ALC299 layout-id 22 for Dell XPS 13 by andreszerocross

>- Added ALC887-VD layout-id 87 for GA-Z97-HD3 ver2.1 by varrtix

> ......



网上也有很多教程教你如何下载AppleALC源码改layout、配合Linux的codec dump去拿到声卡的完整输出输入定义、PathMap，从而自制仿冒声卡的教程，诚然按照这些教程做下来肯定是相当完美，但是笔者经过几天的摸索发现其实完全不用这么复杂，只要每次开机通过```hda-verb```发送一条HD-audio命令，去动态地```SET_PIN_WIDGET_CONTROL```纠正错误的PIN_WIDGET_CONTROL即可。

```
hda-verb 0x19 0x707 0x20
```

基于此思路，我们可以借助macOS的Automator，编写一段非常简单的动作，使得在每次用户登录的时候都执行一下上述命令纠正声卡输出即可。hda-verb工具以及生成的动作App已经附在Repo中。



**以下操作假设hda-verb在/User/\<your-user-name>/目录下**

1. 打开Automator, 选择"应用程序"

2. 左侧任务列表中选择"运行Shell脚本"

3. 右边空白文本区域输入

   ```
   cd ~
   ./hda-verb 0x19 0x707 0x20
   ```

4. 起英文名保存在一个容易发现的地方

5. 系统偏好设置->用户与群组->登录项，添加刚才保存的App即可。

6. 如果不出意外，每次登陆右上角通知Icon区域将会有小齿轮转1s左右，表明已经执行此命令纠正声卡输出。