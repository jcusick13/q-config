## Ubuntu 18.04.3 LTS Installation
Overview of steps taken to install Ubuntu on a new Lenovo Thinkpad X1 Carbon 7th Gen (Late 2019)

* [Requirements](#requirements)
* [Process](#process)
* [Post-Installation](#post-installation)
  * [Temperature throttling](#temperature-throttling)
  * [Volume up/down buttons](#volume-up/down-buttons)
  * [No volume when connected with HDMI](#no-volume-when-connected-with-hdmi)
* [Upgrade to Ubuntu 20.04](#upgrade-to-ubuntu-20.04)
  * [Misconfigured trackpad](#misconfigured-trackpad)
  * [Disable button 2](#disable-button-2)

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
`snd_hda_intel.dmic_detect=0` to the end of the line within the quotes.
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash snd_hda_intel.dmic_detect=0"
```
Update GRUB with `sudo update-grub` and then changes should
take effect upon rebooting. In order to first test this configuration, see
[here](https://askubuntu.com/questions/19486/how-do-i-add-a-kernel-boot-parameter#19487)
for how to temporarily add a boot parameter to a kernel.


#### Upgrade to Ubuntu 20.04
##### Misconfigured trackpad
After upgrading, the trackpad began running into issues when using it to click. The
mouse was still able to move fine when using the trackpad but clicking would act as
if other keys (e.g. shift, etc) were also held down and open things in new tabs,
close windows entirely, and other issues.

Based on [this answer](https://askubuntu.com/questions/1235067/touchpad-stopped-working-20-04).

Note, can boot into BIOS with the below.
```
sudo systemctl reboot --firmware
```

##### Disable button 2
When clicking in the middle of the trackpad, unexpected behavior (somewhat alluded to
above) was encountered. Using `xev`, it was determined the the center of the trackpad
was allocated to `button 2`, as opposed to `button 1` for left-click and `button 3`
for right-click.

As described in [this answer](
https://unix.stackexchange.com/questions/438725/disabling-middle-click-on-bottom-of-a-clickpad-touchpad),
`xinput` can be used to disable the unwanted button. First, determine the device ID of the trackpad
with `xinput list` (currently 12) and view the current button mapping.
```
xinput get-button-map 12
1 2 3 4 5 6 7
```
Next, determine what the button mapping values correspond to with `xinput list 12`.
After confirming that 2 in fact maps to `button 2`, set it to 1, left-click, to allocate the left
two-thirds of the trackpad to left-click and the remaining right third to right-click.
```
xinput set-button-map 12 1 1 3 4 5 6 7
```


