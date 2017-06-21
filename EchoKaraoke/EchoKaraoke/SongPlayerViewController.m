//
//  SongPlayerViewController.m
//  Karaoke
//
//  Created by echo on 5/31/15.
//  Copyright (c) 2015 echo. All rights reserved.
//

#import "SongPlayerViewController.h"
#import "SongPlayer.h"

@interface SongPlayerViewController()
@property (nonatomic, strong, readwrite) Song *song;
@property (nonatomic, strong, readwrite) SongPlayer *player;
@end

@implementation SongPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

// player setup takes a few seconds on slower devices
// loading in viewDidAppear instead of viewDidLoad makes the list more responsive
- (void)viewDidAppear:(BOOL)animated {
    if (!self.player) {
        self.player = [[SongPlayer alloc] initWithSong:self.song];
    }
    
    [super viewDidAppear:animated];
}

// must be called before pushing the view!
- (void)setSong:(Song *)song {
    _song = song;
    self.title = song.title;
}

- (IBAction)playSong:(id)sender {
    // the image view might not be loaded when setSong is called.  I hate storyboard
    self.player.imageView = self.imageView;
    [self.player play];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.player stop];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
