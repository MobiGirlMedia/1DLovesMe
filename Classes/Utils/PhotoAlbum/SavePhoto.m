//
//  SavePhoto.m
//  paperdolls
//
//  Created by Alexander Morgun, Andrew Kopanev on 4/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SavePhoto.h"


@implementation SavePhoto


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


- (BOOL) isPad {
#ifdef UI_USER_INTERFACE_IDIOM
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
    return NO;
#endif
}


- (UIImage*) getCurrentImage {
    
	if (self.isPad) {
		UIGraphicsBeginImageContext(CGSizeMake(640, 960));
	}
	else UIGraphicsBeginImageContext(CGSizeMake(320, 480));
	
	[tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (void)makeCache {
	// create screen dump of the view of this view controller
	NSString *imageFilePath = nil;
	int imageIndex = 0;
	NSString *prefix = cover ? @"covers/" : @"";
	while (!imageFilePath) {
		NSString *checkFilePath = [NSString stringWithFormat: @"%@/%@%05d.png", [Helper getUserImagesFolder], prefix, imageIndex++];
		if (![[NSFileManager defaultManager] fileExistsAtPath: checkFilePath]) {
			imageFilePath = checkFilePath;
			break;
		}
	}
	
	NSLog(@"result: %@", imageFilePath);
	
	//	NSData *imageBytes = UIImageJPEGRepresentation(tempImg, .9);
	NSData *imageBytes = UIImagePNGRepresentation(tempImg);
	BOOL saved = [imageBytes writeToFile: imageFilePath atomically: NO];
	if (!saved) {
		NSLog(@"error! can't save image at path: %@", imageFilePath);
	}
}

- (void)windowOfLevel: (UIImageView *)levelView withCover:(BOOL)_cover {
	tempView = levelView;
	cover = _cover;
	
	tempImg = [self getCurrentImage];
	
	if (cover) {
		int x2 = [self isPad] ? 2 : 1;
		
		CGRect size = (x2 == 2)? CGRectMake(59*x2, 88*x2, 265*x2, 347*x2) : CGRectMake(27*x2, 74*x2, 265*x2, 347*x2);
		
		CGImageRef imageRef = CGImageCreateWithImageInRect([tempImg CGImage], size);
		// or use the UIImage wherever you like
		tempImg = [UIImage imageWithCGImage:imageRef]; 
		CGImageRelease(imageRef);
	}
	
	[self makeCache];
}


- (void)dealloc {
	[super dealloc];
}


@end