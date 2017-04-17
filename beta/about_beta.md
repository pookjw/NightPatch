This is beta version. Not stable yet.

# Running beta version

Enter this command on Terminal **without $**.

`$ cd /tmp; curl -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o NightPatch.zip; cd NightPatch-master/beta; ./NightPatch.sh`

# What's New?

Now you can revert system file using macOS Combo Update. (will download from Apple.) **It works without backup.**

Only for 10.12.4 (16E195).

Revert using backup (old)

`$ cd /tmp; curl -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o NightPatch.zip; cd NightPatch-master/beta; ./NightPatch.sh -revert`

Revert using macOS Combo Update (NEW)

`$ cd /tmp; curl -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o NightPatch.zip; cd NightPatch-master/beta; ./NightPatch.sh -revert -download`
