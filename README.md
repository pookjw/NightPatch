![Image](https://farm1.staticflickr.com/580/33704162375_e0883536cf_o.png)

# NightPatch

Enable Night Shift on any old Mac models.

You have to disable SIP (System Integrity Protection) before applying. [How to disable SIP](http://apple.stackexchange.com/a/209530)

Backup your Mac before applying.

Not compatible with some third-party monitors.

Referenced [Pike's blog](https://pikeralpha.wordpress.com/2017/01/30/4398/).

## Supported macOS build

- macOS 10.12.4 (16E195)

- macOS 10.12.5 Developer Preview 1 (16F43c)

- macOS 10.12.5 Developer Preview 2 (16F54b)

- macOS 10.12.5 Public Beta 1 (16F43c)

- macOS 10.12.5 Public Beta 2 (16F54b)

## How to patch

Enter this command on Terminal **without $**.

`$ cd /tmp; curl -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o NightPatch.zip; cd NightPatch-master; ./NightPatch.sh`

## How to revert

NightPatch will revert using backup located at /Library/NightPatch. Enter this command on Terminal **without $**.

`$ cd /tmp; curl -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o NightPatch.zip; cd NightPatch-master; ./NightPatch.sh -revert`

If you deleted backup (or not backuped), enter this command on Terminal **without $**. NightPatch will download original system file from Apple. (**Only for macOS 10.12.4 (16E195)**.)

`$ cd /tmp; curl -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o NightPatch.zip; cd NightPatch-master; ./NightPatch.sh -revert combo`

## Troubleshooting

- patch/BUILD.patch is missing.

: That’s because I didn’t make a patch file for your macOS. I’ll make for you when it possible.

- ERROR : Turn off System Integrity Protection before doing this. / ERROR : Can't write a file to root.

: [Solution](http://apple.stackexchange.com/a/209530)
