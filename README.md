## Dell Inspiron 7590 Hacktonish Guide

English version is being written, please wait for a few days.

This is a Chinese version.

**更新日志**

>2019年09月28日 新增Custom SSDT屏蔽无用USB接口，需要配合USBInjectAll使用。新增SSDT-ALC295，修正多次重启后找不到声卡的问题。
>
>2019年09月27日 增加patch AppleHDA的教程。

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

   读卡器正常

   雷点3接口仅支持使用Typc-C设备

3. 不正常功能

   WIFI, 蓝牙无解

   独显无解，已屏蔽

   调节亮度的组合键不是Fn+F6 Fn+F7，而是Fn+S, Fn+B（尝试BRT6 to BRTX失败。暂时没有深究原因）

   机器自带麦克风失效

   HDMI 输出不正常

已测试系统版本: mojave 10.14.2 10.14.6

**0x01 如何使用**

本EFI基于[@xiaoMGithub](https://github.com/xiaoMGitHub/LEGION_Y7000Series_Hackintosh_Clover)的拯救者Y7000配置文件。为了表示对作者的感谢，笔者保留了此EFI的Clover Theme，如有需要可以自行更换。

本EFI不区分安装时引导和正常引导，你可以使用这个EFI安装/引导使用Mojave。使用方法与其他EFI一样，替换引导介质EFI分区中的EFI文件即可。详细的安装过程请参考其他macOS安装指南。

完成安装/引导启动macOS后请继续往下看。

**0x02 修复耳机孔发声不正常**

当您使用此EFI完成macOS安装进入系统，不出意外的话整个系统看上去是正常的，但是此时将耳机插入耳机孔，会发现音乐听不到人声，只能听到背景音，就好像耳机没有完全插入耳机孔一样。如果您进入系统偏好设置->声音->输出，将平衡滑条调到最左或者最右，却能听到人声。

有时候系统重启、或者从睡眠中恢复，会发现喇叭变灰，找不到输出设备。

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

网上也有很多教程教你如何下载AppleALC源码改layout、配合Linux的codec dump去拿到声卡的完整输出输入定义、PathMap，从而自制仿冒声卡的教程，诚然按照这些教程做下来肯定是相当完美，但是笔者经过几天的摸索发现其实完全不用这么复杂，只要写一个简单的Action在每次开机时自动纠正声卡输出即可。

**注意:**

1. 本机型Patch AppleHDA的方式不能完全按照网上通用的Guide来做，有一些步骤需要改动。

2. 请确保当前系统的AppleHDA没有经过任何修改。

3. 经过笔者前一天的测试(2019.9.27)发现通过注入SSDT补丁可以修复多次重启、进Windows后重启等找不到声卡的问题。所以如果进系统后发现喇叭正常运行，请先直接跳到步骤4制作修正声卡输出的Automator，并试着多重启几次。没有问题的话**不需要Patch AppleHDA。**

**步骤:**

1. Patch AppleHDA

   备份系统原版AppleHDA

   ```shell
   sudo cp -R /System/Library/Extensions/AppleHDA.kext .
   ```

   此时AppleHDA原版已经复制到当前终端所在文件夹下。

   运行AppleHDAPatcher工具，拖入先前备份出来的原版AppleHDA

   选择Laptop -> ALC 295

   点击Patch

   完成后会在桌面生成`MironeAudio`文件夹

2. 替换系统原版AppleHDA

   ```shell
   sudo cp -R ~/Desktop/MironeAudio/10ec0295/282.54/full Patched AppleHDA/AppleHDA.kext /System/Library/Extensions
   # 10ec0295 和 282.54可能因人而异，需要根据实际情况替换。
   sudo kextcache -i /
   ```

   等待系统重建缓存完成

3. 修改config.plist

  首先确保ACPI设置中FixHDA, AddHDMI的勾选全部去掉，并且System IRQ修复已经应用（本仓库的config.plist已经完成此设置）

  然后DSDT补丁中添加一行（本仓库config.plist已完成设置）

  ```
  Rename HDAS to HDEF, Find=48444153, Replace=48444546
  ```

  "设备设置"中，Audio注入No，右边两个勾不要选。

  根据目前最新的AppleALC官方usage, 目前AppleALC已经不再使用设备设置来Inject，

  需要在下面的Properties中注入layout-id。本仓库的config.plist已经默认在PciRoot(0x0)/Pci(0x1f,0x3)上注入layout-id=77。如果其他用户发现对于这个设置而言效果不好，请按照接下来的步骤做，否则直接跳到下一点。

  重启电脑，目的是让Rename HDAS to HDEF被应用, 然后打开终端，分别输入

  ```
  kextstat | grep AppleHDA
  
  kextstat | grep AppleALC
  ```

  确保AppleALC前面的序号在AppleHDA之前。（AppleALC必须在AppleHDA之前被加载）

  使用gfxutil获取HDEF设备的PciRoot

  终端输入

  ```
  ./gfxutil -f HDEF
  ```

  记下DevicePath, 替换掉config.plist的Properties中的值，至于layout-id可以在13，28，77中来回试。默认AppleHDAPatch推荐的2和3对于戴尔来说**都是不能用的。**

  重启电脑。查看声音输出是否正常。


4. 借助macOS的Automator，在每次用户登录的时候正声卡输出。hda-verb工具以及生成的动作App已经附在Repo中。

	```
	hda-verb 0x19 0x707 0x20
	```
	
	首先尝试在终端下输入以上命令, 完成后插入耳机，平衡调到中间，测试耳机是否已经正常。如果正常，请继续操作，否则跳过下面全部设置，并上网找资料。
	
	以下操作假设hda-verb在/User/\<your-user-name>/目录下**
	
	
	1. 打开Automator, 选择"应用程序"
	
	2. 左侧任务列表中选择"运行Shell脚本"
	
	3. 右边空白文本区域输入
	
	```
	cd ~
	./hda-verb 0x19 0x707 0x20
	```
	
	
	1. 起英文名保存在一个容易发现的地方
	2. 系统偏好设置->用户与群组->登录项，添加刚才保存的App即可。
	3. 如果不出意外，每次登陆右上角通知Icon区域将会有小齿轮转1s左右，表明已经执行此命令纠正声卡输出。
	4. **如果您的电脑从睡眠中唤醒后发现声音又不正常了，请再次执行先前生成的App即可。笔者承认这样做确实很不优雅，但是笔者已经尝试在SSDT-ALC295.dsl里面加入自动使CodecCommander执行上述verb的Custom Command了但是它就是不work。如果有人知道原因还请不吝赐教。**

**0x03 安装USBInjectAll**

​	遵照RehabMan大神的指南，执行以下终端命令

```shell
sudo cp -R /path/to/USBInjectAll.kext /Library/Extensions
sudo touch /System/Library/Extensions && sudo kextcache -u /
```

执行完成后重启, 使用IOReg软件检查XHC@14节点(一般是这个)，看看是不是只有HS01,02,03,04,05,14和SS01,02,03端口，如果不是，可能本EFI中的Custom SSDT不适合您的机器，您可能需要参考[[Guide] Creating a Custom SSDT for USBInjectAll.kext](https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/)来自制一个SSDT替换掉ACPI/patched/SSDT-UIAC.dsl、ACPI/patched/SSDT-UIAC.aml。

（当然如果睡眠没什么问题而您又没有强迫症的话可以不用关USB端口）

**0x04 禁用睡眠**

​	如果机器出现盒盖休眠重启的情况，尝试执行以下终端命令，禁用休眠。

```shell
sudo pmset -a sleep 0
sudo pmset -a disablesleep 1
sudo pmset -a hibernatemode 0
sudo rm /var/vm/sleepimage
sudo mkdir /var/mv/sleepimage

```

​	如果上述命令不能解决问题，尝试执行以下命令删掉PowerManagement配置文件。

```shell
sudo rm cd /Library/Preferences/com.apple.PowerManagement*
```

**0x05 为触控板安装驱动（如果触控板不正常的话）**

​	本EFi中已经放置VoodooPS2Controller.kext到kext/Other目录下了，一般情况下它是能够正常加载的。如果它加载不正常，您可能需要将这个kext安装到/S/L/E下, 具体操作为:

```shell
sudo cp -R /path/to/VoodooPS2Controller.kext /System/Library/Extensions
sudo kextcache -i /
```

重启机器。

检查kext是否成功加载:

```shell
sudo kextstat | grep Voodoo
```

