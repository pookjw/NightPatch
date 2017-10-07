![Image](https://farm5.staticflickr.com/4180/34667770256_33b15e6390_o.jpg)

# NightPatch

Enable Night Shift on any old Mac models.

You have to disable SIP (System Integrity Protection) before applying. [How to disable SIP](http://apple.stackexchange.com/a/209530)

Backup your Mac before applying.

Not compatible with some third-party monitors.

## Supported macOS

macOS 10.12.4 or later including High Sierra. ([List of tested macOS build](https://cvws.icloud-content.com/B/AVYxsv5VywC2vXRd81U-kElVmwnXAVmxhtAdg6XYSsKLeuAaifvMIIH9/list.txt?o=AieT4rzO064NtHLaE5wnkYD2LptAYWtW4Y6KZOMQeMgP&v=1&x=3&a=BfbTx6HgtW4HA3NUPg&e=1507395003&k=F5bmel1QgILywYCyAUFHoA&fl=&r=a47d9276-8fd2-4d1d-97c4-90b091169861-1&ckc=com.apple.clouddocs&ckz=com.apple.CloudDocs&p=54&s=FSPTazwvct7Ymdq8w_YPm7uBdoc))

## How to patch

Enter this command on Terminal **without $**.

`$ cd /tmp; curl -s -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o -qq NightPatch.zip; cd NightPatch-master; chmod +x NightPatch.sh; ./NightPatch.sh`

## How to revert using backup

You can revert using backup located at /Library/NightPatch. (NightPatch creates backup automatically when you patch your macOS) Enter this command on Terminal **without $**.

`$ cd /tmp; curl -s -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o -qq NightPatch.zip; cd NightPatch-master; chmod +x NightPatch.sh; ./NightPatch.sh --revert`

## How to revert using macOS combo Update

If you deleted backup (or not backed up), enter this command on Terminal **without $**. NightPatch will download original system file from Apple.

`$ cd /tmp; curl -s -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o -qq NightPatch.zip; cd NightPatch-master; chmod +x NightPatch.sh; ./NightPatch.sh --fix`

## Troubleshootings

- ERROR : Turn off System Integrity Protection before doing this.

: [Solution](http://apple.stackexchange.com/a/209530)

- 'Password:' ???

: Enter your login password.

## References

[aonez/NightShiftPatcher](https://github.com/aonez/NightShiftPatcher)

[Supported Mac models for Night Shift in Sierra 10.12.4+](https://pikeralpha.wordpress.com/2017/01/30/4398/)
