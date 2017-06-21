//
//  SongPlayerViewController.h
//  Karaoke
//
//  Created by echo on 5/31/15.
//  Copyright (c) 2015 echo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface SongPlayerViewController : UIViewController

// Link this IBOutlet to the UIImageView where the 'video' will play
@property (nonatomic, strong, readwrite) IBOutlet UIImageView *imageView;

// This must be set before pushing SongPlayerViewController!
- (void)setSong:(Song *)song;

// Link this IBAction to start playing
- (IBAction)playSong:(id)sender;

@end
