//
//  PhotoAlbum.h
//  paperdolls
//
//  Created by Alexander Morgun, on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoAlbum : UIView <UIScrollViewDelegate> {
	int currentImageIndex;
	NSMutableArray *imageFilePaths;
	
	UIImageView *prevView;
	UIImageView *photoView;
}

@property (assign) NSMutableArray *imageFilePaths;
@property (assign) UIImageView *photoView;

- (void) showView: (int) numberOfImage;
- (void) hideAlbum;

@end