## Ubuntu 18.04.3 LTS Installation
Overview of steps taken to install Ubuntu on a new Lenovo Thinkpad X1 Carbon 7th Gen (Late 2019)

#### Requirements
* 2 blank USB thumb drives (all other files will be deleted in the setup process)
  * 1 >= 4GB for Ubuntu image
  * 1 >= 16GB for Windows image

#### Process
1. Create a recovery drive of Windows as soon as the computer was turned on and setup, follow
[instructions from Microsoft support](https://support.microsoft.com/en-us/help/4026852/windows-create-a-recovery-drive).
This allows for a full reset back to the state the machine was purchased in case of any major
mistakes.

2. Create a bootable USB drive with the desired copy of Ubuntu, from
[here](https://tutorials.ubuntu.com/tutorial/tutorial-create-a-usb-stick-on-windows#0). This will be
used in order to actually boot and install Ubuntu onto the laptop.

3. Reboot into BIOS to adjust settings for use in a Linux environment. Follow
[these instructions](https://www.laptopmag.com/articles/access-bios-windows-10)
to access BIOS and then change the settings as described below. The bolded items are critical for
installation success. Settings derived from
[blog post here](https://thornelabs.net/posts/installing-ubuntu-1804-lts-on-a-lenovo-thinkpad-x1-carbon-gen-6.html).

    * Config > Network > Wake On LAN: Disabled
    * Config > Network > Wake On LAN from Dock: Disabled
    * **Config > Power > Sleep State: Linux**
    * **Config > Thunderbolt (TM) 3 > Thunderbolt BIOS Assist Mode: Enabled (Default)**
    * Security > Fingerprint > Predesktop Authentication: Off
    * Security > I/O Port Access > Fingerprint Reader: Off
    * **Security > Secure Boot Configuration > Secure Boot: Off**
    * **Startup > Boot > Edit Boot Order: Drag USB HDD to top**

4. Install Ubuntu by inserting the USB stick and then restarting the laptop. More
detailed instuctions from [Ubuntu documentation](https://help.ubuntu.com/community/Installation/FromUSBStickQuick).
See the documentation link to help resolve cases where the laptop boots directly back into Windows.

    * Set up language/wifi
    * Normal installation
    * Erase disk and install Ubuntu
      * Encryption and LVM left _unchecked_

#### Post-Installation
##### Temperature throttling
There is a [noted issue](https://forums.lenovo.com/t5/Other-Linux-Discussions/X1C6-T480s-low-cTDP-and-trip-temperature-in-Linux/td-p/4028489/highlight/true/page/11) that involves temperature throttling when running Linux on certain Lenovo
models, causing them to run less efficiently than if the same machines ran Windows. 
The same linked forum page also provides both firmware and BIOS
updates for the X1 Carbon Gen 7.

The first firmware update could be install directly with `fwupd`, 
more details [here](https://itsfoss.com/update-firmware-ubuntu).
```
sudo apt update && sudo apt upgrade -y
sudo service fwupd start 
sudo fwupdmgr refresh
sudo fwupdmgr update
```

In order to get the second update (BIOS), it was necessary to download the `.cab` file
manually and then install. To do this, I had to upgrade `fwupd` to a version >= 1.1.3.
`apt-get` was saying that the 1.0.9 I was on was the latest version, so I had to install
from the edge channel on `snap` to get the latest version.
```
sudo snap install --channel=edge fwupd
```
From there, it was necesary to invoke `fwupd` directly with `snap` in order to use
the newly downloaded version.
```
sudo snap start fwupd
sudo fwupdmgr install Lenovo...SystemFirmware-1.22.cab
```

Also, though the page is specifically written for ArchLinux,
[this wiki](https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6))
contains a good starting point for troubleshooting different issues.

##### Volume up/down buttons
The volume up and down keys (F2 and F3) show the volume level raising and lowering but don't actually make
an impact in the sound level. Oddly enough, the mute key (F1) does work correctly. According to
[this Reddit post](https://www.reddit.com/r/linux4noobs/comments/d44pdk/cannot_change_volume_can_muteunmute_ubuntu_1904/), edit
`/usr/share/pulseaudio/alsa-mixer/paths/analog-output.conf.common`, adding the
`[Element Master]` block directly above the existing `[Element PCM]` block.
```
[Element Master]
switch = mute
volume = ignore

[Element PCM]
switch = mute
volume = merge
override-map.1 = all
override-map.2 = all-left,all-right
```
Upon restarting, things seemed to work as expected.

##### No volume when connected with HDMI
When plugging in a second monitor with an HDMI cable, the speakers wouldn't play
sound from either the second monitor or the laptop itself, listing "Dummy Output"
as the only speaker set when trying to change the volume.

The issue can be traced back to a bug mentioned
[here](https://bugs.archlinux.org/task/64720). To resolve,
a flag needs to be disabled as described originally in
[this SO post](https://askubuntu.com/questions/1218041/ubuntu-18-04-audio-disappeared-after-update?newreg=0c78cbe09be048a29e59cd99f99019c1).

Permanently disable the required option by editing `/etc/default/grub`.
Find the line beginning with `GRUB_CMDLINE_LINUX_DEFAULT` and add
`snd_hda_intel.dmic_detect=0` to the end of the line and changes should
take effect upon rebooting. In order to first test this configuration, see
[here](https://askubuntu.com/questions/19486/how-do-i-add-a-kernel-boot-parameter#19487)
for how to temporarily add a boot parameter to a kernel.

