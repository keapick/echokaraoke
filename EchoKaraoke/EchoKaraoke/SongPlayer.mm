//
//  SongPlayer.mm
//  Karaoke
//
//  Created by echo on 5/31/15.
//  Copyright (c) 2015 echo. All rights reserved.
//

#import "SongPlayer.h"
#import "Song.h"
#import "UIImage+RGB.h"

// C++ class used to read cdg files
#include "libCDG.h"

@interface SongPlayer()
@property (nonatomic, strong, readwrite) Song *song;
@property (nonatomic, strong, readwrite) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong, readwrite) CADisplayLink *displayLink;
@end

@implementation SongPlayer

CDG *cdg;

- (instancetype)initWithSong:(Song *)song {
    self = [super init];
    if (self) {
        self.song = song;
    }
    return self;
}

- (void)play {
    if (![self.audioPlayer isPlaying]) {
        [self loadCdg:self.song.cdgPath];
        [self playMp3:self.song.mp3Path];
    }
}

- (void)stop {
    [self.audioPlayer stop];
    [self cleanup];
}

// this is required to avoid a huge memory leak
- (void)cleanup {
    // unlink from audio
    self.audioPlayer.delegate = nil;
    
    // unlink the display
    [self.displayLink invalidate];
    self.displayLink = nil;
    
    // clean up cdg class
    if (cdg) {
        if (cdg->IsOpen()) {
            cdg->VideoClose();
        }
        
        delete cdg;
        cdg = NULL;
    }
}

- (NSURL *) documentsURL {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    if (path) {
        return [NSURL fileURLWithPath:path];
    }
    return nil;
}

- (NSData *)dataForMp3File:(NSString *)mp3File {
    NSURL *mp3URL = [[self documentsURL] URLByAppendingPathComponent:mp3File];
    return [NSData dataWithContentsOfURL:mp3URL];
}

- (void)playMp3:(NSString *)mp3File {
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:[self dataForMp3File:mp3File] error:&error];
    self.audioPlayer.delegate = self;

    if (!error) {
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    } else {
        NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
    }
}

- (NSString *)pathForCdgFile:(NSString *)cdgFile {
    NSURL *cdgURL = [[self documentsURL] URLByAppendingPathComponent:cdgFile];
    return cdgURL.path;
}

- (void)loadCdg:(NSString *)cdgFile {
    NSString *pathToCdgFile = [self pathForCdgFile:cdgFile];
    std::string *path = new std::string([pathToCdgFile UTF8String]);
    
    cdg = new CDG();
    if (cdg->FileOpen(*path)) {
        cdg->Process();
        
        // link video update to UI refresh
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateVideo)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    delete path;
}

- (void)updateVideo {
    if (self.audioPlayer.isPlaying) {
        NSTimeInterval timeInterval = self.audioPlayer.currentTime;
        if (timeInterval > 0) {
            NSUInteger timeInteger = round(timeInterval * 1000);
            
            if (!cdg->SkipFrame((unsigned int)timeInteger)) {
                unsigned char *buffer = cdg->GetImageByTime((unsigned int)timeInteger);
            
                // cdg images are 300 x 216
                UIImage *image = [UIImage imageWithRGBA:buffer withWidth:300 withHeight:216];
                if (self.imageView) {
                    self.imageView.image = image;
                }
                
                delete buffer;
            }
        }
    }
}

// need to clean up when the audio finishes
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.imageView) {
        self.imageView.image = nil;
    }
    
    [self cleanup];
}

@end
