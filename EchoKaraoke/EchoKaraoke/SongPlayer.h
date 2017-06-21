//
//  SongPlayer.h
//  Karaoke
//
//  Created by echo on 5/31/15.
//  Copyright (c) 2015 echo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "Song.h"

@interface SongPlayer : NSObject <AVAudioPlayerDelegate>

// used to show lyrics
@property (nonatomic, weak, readwrite) UIImageView *imageView;

- (instancetype)initWithSong:(Song *)song;

- (void)play;
- (void)stop;

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;

@end
