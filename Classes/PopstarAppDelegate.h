//
//  PopstarAppDelegate.h
//  Popstar
//
//  Created by Alexander Morgun on 8/22/11.
//  Copyright 2011 InjoiT.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PopstarViewController.h"

#import "LoadingView.h"
#import "MBProgressHUD.h"

#import "Girl.h"


//@class PopstarViewController;

@interface PopstarAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	AVAudioPlayer *backgrSound; //was AVAudioPlayer
	AVAudioPlayer *cameraSound;
	AVPlayer *userSounds;
	
	NSFileManager* fileManager;
	NSMutableDictionary *oldList;
	NSMutableDictionary *newList;
	NSString *newPath;
	
	BOOL bigCover;
	BOOL useriPod;

@private
	MBProgressHUD *HUD;
	BOOL HUDOnScreen;
	
@public
    PopstarViewController *viewController;

}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PopstarViewController *viewController;

@property (nonatomic, assign) AVAudioPlayer *backgrSound;
@property (nonatomic, assign) AVAudioPlayer *cameraSound;
@property (nonatomic, assign) AVPlayer *userSounds;

@property (nonatomic, retain) UIImage *myPhoto;

@property BOOL bigCover;
@property BOOL useriPod;

- (void) bigCover: (BOOL) state;

- (void) startPlay;

- (void) reviewCounter;

- (void)showHUD;
- (void)hideHUD;

- (BOOL)internetConnected;

- (BOOL) isPad;

@end