![Image](https://farm5.staticflickr.com/4190/34470110995_dd069e64ce_o.png)

# NightPatch

Enable Night Shift on any old Mac models.

You have to disable SIP (System Integrity Protection) before applying. [How to disable SIP](http://apple.stackexchange.com/a/209530)

Backup your Mac before applying.

Not compatible with some third-party monitors.

Referenced [Pike's blog](https://pikeralpha.wordpress.com/2017/01/30/4398/).

## Supported macOS build

- macOS 10.12.4 (16E195)

- macOS 10.12.5 (16F73)

- macOS 10.12.6 Developer Beta 1 (Coming Soon)

[View more](macOS_list.md)

## How to patch

Enter this command on Terminal **without $**.

`$ cd /tmp; curl -s -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o -qq NightPatch.zip; cd NightPatch-master; chmod +x NightPatch.sh; ./NightPatch.sh`

▼ GIF ▼

![Image](https://raw.githubusercontent.com/pookjw/gif/master/Image2.gif)

▲ GIF ▲

## How to revert

You can revert using backup located at /Library/NightPatch. (NightPatch creates backup automatically when you patch your macOS) Enter this command on Terminal **without $**.

`$ cd /tmp; curl -s -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o -qq NightPatch.zip; cd NightPatch-master; chmod +x NightPatch.sh; ./NightPatch.sh -revert`

If you deleted backup (or not backed up), enter this command on Terminal **without $**. NightPatch will download original system file from Apple. (**Not for macOS Beta**.)

`$ cd /tmp; curl -s -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o -qq NightPatch.zip; cd NightPatch-master; chmod +x NightPatch.sh; ./NightPatch.sh -revert combo`

## Troubleshootings

- ERROR : Turn off System Integrity Protection before doing this.

: [Solution](http://apple.stackexchange.com/a/209530)

- 'Password:' ???

: Enter your login password.

- ERROR : I can't find patch/[BUILD].patch file.

: That’s because I didn’t make a patch file for your macOS. I’ll make for you when it possible.

## Document for expert

- [Creating patch file](https://github.com/pookjw/NightPatch/wiki/Creating-patch-file) (for unsupported macOS build)

- [NightPatch options](https://github.com/pookjw/NightPatch/wiki/NightPatch-options)
