# echokaraoke
A Simple iOS app that plays mp3+cdg files.
======

**Karaoke app**

Once songs are loaded via iTunes, press the refresh button to load a list of songs on the device.

![Song list](/screenshots/songlist.jpg "Song list on iPod Touch 5G")

Touch the screen to start playing.  Should probably add a play button here.

![Playing a song](/screenshots/playing.jpg "Playing a Karaoke song on iPod Touch 5G")

**Loading songs**

Songs are added via iTunes.  Note that CDG and MP3 filenames must match.  Also there is no support for Zipped files in the demo app.

![Adding Songs](/screenshots/itunes.png "Adding songs via iTunes")

**Acknowledgements**

libCDG is used for low level CDG processing.  It is a part of [OpenKJ](https://github.com/coyote1357/OpenKJ).

[UIImage-Conversion](https://github.com/PaulSolt/UIImage-Conversion) is used to convert raw CDG data to a UIImage.

