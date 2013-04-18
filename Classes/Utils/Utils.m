//
//  Utils.m
//  CaliGirl
//
//  Created by  on 11/20/10.
//  Copyright 2010 Injoit.com. All rights reserved.
//

#import "Utils.h"


@implementation Utils

+ (NSString *) documentsDirectory {
	static NSString* dPath = nil;
	if (!dPath) {
		dPath = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
		[dPath retain];
	}
	return dPath;	
}

+ (NSString *) bundlePath {
	return [[NSBundle mainBundle] bundlePath];
}

+ (NSString *) imagesDirectory {
	static NSString* dPath = nil;
	if (!dPath) {
		dPath = [NSString stringWithFormat: @"%@/images", [Utils bundlePath]];
		[dPath retain];
	}
	return dPath;	
}

+ (NSString *) magazineDirectory {
	static NSString* dPath = nil;
	if (!dPath) {
		dPath = [NSString stringWithFormat: @"%@/magazine", [Utils documentsDirectory]];
		if (![[NSFileManager defaultManager] fileExistsAtPath: dPath]) {
			[[NSFileManager defaultManager] createDirectoryAtPath: dPath
									  withIntermediateDirectories: NO
													   attributes: nil
															error: nil];
		}
		[dPath retain];
	}
	return dPath;	
}

+ (NSMutableArray *) magazineImages {
	NSMutableArray * ra = [NSMutableArray array];
	NSString * magDir = [Utils magazineDirectory];
	NSArray * contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: magDir
																			 error: nil];
	for (NSString * s in contents) {
		[ra addObject: [NSString stringWithFormat: @"%@/%@", magDir, s]];
	}
	return ra;
}

+ (NSMutableArray *) dressImagesFor: (NSString *) dressFolder {
	NSMutableArray * rArray = [NSMutableArray array];
	NSString * fPath = [NSString stringWithFormat: @"%@/%@", [Utils imagesDirectory], dressFolder];
	NSArray * content = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: fPath
																			error: nil];
	for (NSString * s in content) {
		[rArray addObject: [NSString stringWithFormat: @"%@/%@", fPath, s]];
	}
	return rArray;
}

+ (AVAudioPlayer *) playerWithFilePath: (NSString *) fPath {
	AVAudioPlayer * p = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: fPath]
															   error: nil];
	return [p autorelease];
}

+ (void) playSound: (AVAudioPlayer *) player {
	if (player.playing) {
		player.currentTime = 0;
	} else {
		[player play];
	}	
}


+ (NSString *) uniqueFileName {
	NSDateFormatter * dfrm = [[NSDateFormatter alloc] init];
	[dfrm setDateFormat: @"MM_dd_YY_hh_mm_ss_AA"];
	NSString * name = [dfrm stringFromDate: [NSDate date]];
	[dfrm release];
	return name;
}

+ (UIImage*) imageOfView: (UIView *) v {
	UIGraphicsBeginImageContext(v.bounds.size);
	[v.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;	
}

+ (UIView *) waitingViewWithFrame: (CGRect) fr {
	UIView * v = [[UIView alloc] initWithFrame: fr];
	v.userInteractionEnabled = YES;
	v.backgroundColor = [UIColor colorWithRed: 0
										green: 0
										 blue: 0
										alpha: 0.6];
	
	float is = 35;
	UIActivityIndicatorView * iv = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(fr.size.width * .5 - is * .5, fr.size.height * .5 - is * .5, is, is)];
	[iv startAnimating];
	iv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[v addSubview: iv];
	[iv release];
	
	return [v autorelease];
}

@end
