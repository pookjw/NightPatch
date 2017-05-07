![Image](https://farm5.staticflickr.com/4190/34470110995_dd069e64ce_o.png)

# NightPatch

Enable Night Shift on any old Mac models.

You have to disable SIP (System Integrity Protection) before applying. [How to disable SIP](http://apple.stackexchange.com/a/209530)

Backup your Mac before applying.

Not compatible with some third-party monitors.

Referenced [Pike's blog](https://pikeralpha.wordpress.com/2017/01/30/4398/).

## Supported macOS build

[View](macOS_list.md)

## How to patch

Enter this command on Terminal **without $**.

`$ cd /tmp; curl -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o NightPatch.zip; cd NightPatch-master; chmod +x NightPatch.sh; ./NightPatch.sh`

▼ GIF ▼

![Image](Image1.gif)

▲ GIF ▲

## How to revert

You can revert using backup located at /Library/NightPatch. (NightPatch creates backup automatically when you patch your macOS) Enter this command on Terminal **without $**.

`$ cd /tmp; curl -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o NightPatch.zip; cd NightPatch-master; chmod +x NightPatch.sh; ./NightPatch.sh -revert`

If you deleted backup (or not backed up), enter this command on Terminal **without $**. NightPatch will download original system file from Apple. (**Only for macOS 10.12.4 (16E195)**.)

`$ cd /tmp; curl -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o NightPatch.zip; cd NightPatch-master; chmod +x NightPatch.sh; ./NightPatch.sh -revert combo`

## Troubleshooting

- ERROR : I can't find patch/[BUILD].patch file.

: That’s because I didn’t make a patch file for your macOS. I’ll make for you when it possible.

- ERROR : Turn off System Integrity Protection before doing this. / ERROR : Can't write a file to root.

: [Solution](http://apple.stackexchange.com/a/209530)

- ERROR : SHA not matching. Patch was failed.

: Seems like your macOS system file was damaged or patched by other tool or not supported. Try this command to replace original system file to your macOS. (will download from Apple. **Only for macOS 10.12.4 (16E195)**.)

`$ cd /tmp; curl -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o NightPatch.zip; cd NightPatch-master; chmod +x NightPatch.sh; ./NightPatch.sh -revert combo`

And patch again.

- ERROR : Requires Command Line Tool. Enter `xcode-select --install` command to install this.

: Try `xcode-select --install` command.

- ERROR : Requires lzma.

: Install **brew** from [here](https://brew.sh) and try `brew install xz` command.
