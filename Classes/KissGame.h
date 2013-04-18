//
//  Models.h
//  Popstar
//
//  Created by Alexander Morgun on 8/22/11.
//  Copyright 2011 InjoiT.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobiGirl/MGAd.h>
//#import <AVFoundation/AVFoundation.h>
#import "PopstarAppDelegate.h"

@interface KissGame : UIViewController {
	BOOL justinTouch;
	BOOL gameEnd;
	BOOL waitNext;
    MGAd *ad;
	NSTimer *timer;
	
	UIImageView *kiss;
//	UIImageView *justin;
	
	AVAudioPlayer *kissSound,*sound;

	int numberItem;
	int gotKisses;
}

@property(nonatomic,retain) AVAudioPlayer *kissSound,*sound;

- (void) action;
- (void) showResult: (NSString *)result;

- (void) back;

- (void) checkIn;

+ (CGPoint) locationItem;

+ (AVAudioPlayer *) createSound: (NSString *)soundName;

@end