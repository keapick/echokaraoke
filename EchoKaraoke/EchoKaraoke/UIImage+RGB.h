//
//  UIImage+RGB.h
//  Karaoke
//
//  Created by echo on 5/31/15.
//  Copyright (c) 2015 echo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RGB)

+ (UIImage *) imageWithRGBA:(unsigned char *) buffer withWidth:(int) width withHeight:(int) height;

@end
