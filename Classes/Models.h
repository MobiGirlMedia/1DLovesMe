//
//  Models.h
//  Popstar
//
//  Created by Alexander Morgun on 8/22/11.
//  Copyright 2011 InjoiT.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbum.h"
#import <MobiGirl/MGAd.h>

@interface Models : UIView <UIScrollViewDelegate> {
	UIView *platform;
	
	UIScrollView *scrollView;
		
	//Big cover
	PhotoAlbum *photoAlbum;
	NSTimer *timer;
	UIView *bigCover;
	PopstarAppDelegate *app;
    MGAd *ad;
    UIViewController * viewController;
}

@property(nonatomic,retain) UIViewController * viewController;

- (id)initWithFrame:(CGRect)frame controller:(UIViewController*) _vc;

- (void) updateCovers;
- (void) update;

- (void) showBigCover: (UIButton *)sender;

- (void) back;



@end