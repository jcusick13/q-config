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
There is a [noted issue](https://forums.lenovo.com/t5/Other-Linux-Discussions/X1C6-T480s-low-cTDP-and-trip-temperature-in-Linux/td-p/4028489/highlight/true/page/11) that involves temperature throttling when running Linux on certain Lenovo
models, causing them to run less efficiently than if the same machines ran Windows. The same linked forum
page also provides both firmware and BIOS updates for the X1 Carbon Gen 7.

All firmware updates can be collected and installed at once with
```
sudo apt update && sudo apt upgrade -y
sudo service fwupd start 
sudo fwupdmgr refresh
sudo fwupdmgr update
```

Also, though the page is specifically written for ArchLinux, [this wiki](https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6))
contains a good starting point for troubleshooting different issues.
