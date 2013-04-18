//
//  MusicPage.h
//  Popstar
//
//  Created by Alexander Morgun on 8/30/11.
//  Copyright 2011 InjoiT.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MusicPlayerViewController.h"

@interface MusicPage : UIView <MPMediaPickerControllerDelegate> {
    UIView *platform;

    UIViewController *controller;    
    //MPMusicPlayerController *musicPlayer; not needed!
}

//@property (nonatomic, retain) MPMusicPlayerController *musicPlayer; not needed!

- (void) openMediaPicker;


@end