Modified libCDG to work with iOS.

1.  iOS does not support 24 bit RGB.  Added an unused alpha to bring it to 32 bit RGBA.
2.  Older devices do not have enough RAM to load the whole video.  I drop the frame rate.
3.  Fixed minor out of range error.

- Ernest Cho
