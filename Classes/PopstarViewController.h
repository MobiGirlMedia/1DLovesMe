//
//  PopstarViewController.h
//  Popstar
//
//  Created by Alexander Morgun on 8/22/11.
//  Copyright 2011 InjoiT.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Girl.h"
#import "FlurryAnalytics.h"
#import "KissGame.h"
#import <MobiGirl/MGAd.h>

@class Models;
@class Girls;


@interface PopstarViewController : UIViewController <GirlsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate> {
	UIView *canvas;
    UIToolbar *theEditToolbar;
    UIToolbar *theToolbar;
    UIImageView *OverLay,*tempImg;
    UIView *EditView;
    UIImage *img1;
    UIImage *roundedImage;
	IBOutlet UIImageView *start_frame,*ivBorder;
	IBOutlet UIView *startScreen;
	IBOutlet UIImageView *start_bgd;
	IBOutlet UIButton *start_button;
    UIImagePickerController *ipcImage;
    UIImageView *ivTemp1,*ivTemp2;
    UIImageView *ivTemp3;
	IBOutlet UIView *mainView;
	IBOutlet UIImageView *main_background;
	IBOutlet UIButton *main_model;
	IBOutlet UIButton *main_kissing;
    IBOutlet UIButton *main_Camera;
    UIImageView *ivTemp;
	UIButton *unlockButton;
    UIImageView *ivPhoto;
	short int shake;
    CGFloat _lastScale;
	CGFloat _lastRotation;
	CGFloat _firstX;
	CGFloat _firstY;
    Girls *girls;
	UIButton *startGame;
	AVAudioPlayer *kissSound;
    
    MGAd *ad;
	
@public    
	BOOL dressUp;
}

@property (nonatomic, retain) UIImageView *start_frame;
@property (nonatomic, retain) UIView *startScreen;
@property (nonatomic, retain) UIImageView *start_bgd;
@property (nonatomic, retain) UIButton *start_button;

@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) IBOutlet UIImageView *main_background,*tempImg;
@property (nonatomic, retain) UIButton *main_model;
@property (nonatomic, retain) UIButton *main_kissing;
@property (nonatomic, retain) UIButton *main_Camera;
@property (nonatomic, retain) Girls *girls;

@property (assign) UIButton *unlockButton;

@property BOOL dressUp;


- (void)choiceGirl: (UIButton *)btn;

- (IBAction)styleNow;
- (IBAction)startKissingGame;
- (IBAction)models;


@end