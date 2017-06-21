//
//  Song.m
//  EchoKaraoke
//
//  Created by echo on 6/17/17.
//  Copyright © 2017 echo. All rights reserved.
//

#import "Song.h"

@implementation Song

+ (Song *)songWithTitle:(NSString *)title mp3Path:(NSString *)mp3Path cdgPath:(NSString *)cdgPath {
    Song *song = [[Song alloc] init];
    song.title = title;
    song.mp3Path = mp3Path;
    song.cdgPath = cdgPath;
    return song;
}

@end
