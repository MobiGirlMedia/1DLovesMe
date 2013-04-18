//
//  Utils.h
//  CaliGirl
//
//  Created by  on 11/20/10.
//  Copyright 2010 Injoit.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define kImagePathKey			@"img"
#define kSoundPathKey			@"snd"

#define kContolCenter			@"kContolCenter"
#define kZeroAllowed			@"kZeroAllowed"
#define kIndexKey				@"kIndexKey"
#define kStartPointKey			@"kStartPointKey"
#define kEndPointKey			@"kEndPointKey"
#define kImagesKey				@"kImagesKey"
#define kImageKey				@"kImageKey"
#define kImageViewKey			@"kImageViewKey"
#define kCurrrentImageKey		@"kCurrrentImageKey"

#define kControlKey				@"kControlKey"

#define kButtonsHideTime		8.0

@interface Utils : NSObject {
	
}

+ (NSString *) documentsDirectory;
+ (NSString *) imagesDirectory;
+ (NSString *) magazineDirectory;
+ (NSMutableArray *) magazineImages;

+ (NSMutableArray *) dressImagesFor: (NSString *) dressFolder;

+ (AVAudioPlayer *) playerWithFilePath: (NSString *) fPath;
+ (void) playSound: (AVAudioPlayer *) player;

+ (NSString *) uniqueFileName;

+ (UIImage*) imageOfView: (UIView *) v;

+ (UIView *) waitingViewWithFrame: (CGRect) fr;

@end
