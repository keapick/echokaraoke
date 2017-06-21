//
//  Song.h
//  EchoKaraoke
//
//  Created by echo on 6/17/17.
//  Copyright © 2017 echo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject
@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSString *mp3Path;
@property (nonatomic, strong, readwrite) NSString *cdgPath;

+ (Song *)songWithTitle:(NSString *)title mp3Path:(NSString *)mp3Path cdgPath:(NSString *)cdgPath;

@end
