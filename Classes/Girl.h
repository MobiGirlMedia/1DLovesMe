//
//  Girls.h
//  Popstar
//
//  Created by Alexander Morgun on 8/22/11.
//  Copyright 2011 InjoiT.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

#import "MusicPage.h"
#import "SavePhoto.h"
#import "ChoiceOfCover.h"
#import "MKStoreManager.h"
#import <MobiGirl/MGAd.h>

@protocol GirlsDelegate; 


@interface Girls : UIViewController <UIAlertViewDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate, MKStoreKitDelegate> {
    id<GirlsDelegate> delegate;
	MGAd *ad;
@private
	
	UIView *platform;
	UIImageView *boy;
	AVAudioPlayer *buy, *photoSound, *putOnSound;
	
    UIImageView *backImageView;
    
    UIImageView *draggedItem;
	
	UIView *modelView, *controlsView;

    
	UIButton *categoryBtn[6];
	UIButton *wardrobeBtn[6];
	UIImageView *girl;
	short int backIndex;
	int girlIndex;
    int originalGirl;
	UIImage *img;
	short int wardrobeIndex;
    UIScrollView *scrollView;
	
	NSMutableDictionary *items;
    NSMutableArray *itemsList;

	NSMutableArray *wearedItems, *boyWearedItems, *currentItemsArray;
    
    NSMutableArray *controls;
    
//    NSTimer *dissapearTimer;
    
    UIActivityIndicatorView *aiv;

	float minimumScale;
	
	UIImageView *girlClothes[14];
	UIImageView *boyClothes[14];
	
	UIScrollView *imageScrollView;
	
	
}

//@property (nonatomic, retain) IBOutlet UIScrollView *imageScrollView;
@property (assign, readwrite) int  number;
@property (nonatomic,retain)id<GirlsDelegate>delegate;
@property (nonatomic, retain) IBOutlet UIImageView *ivFaceImage;
@property (nonatomic, retain) UIImage *imgFaceImage;
- (void) playBuy;

- (void) back;
- (void) showMucisPage;
- (void) makePhoto;

- (void) timerInitialization;

- (void) clothingOfGirl;

- (void) selectCategory:(UIButton *)btn;
- (void) switchWardrobe:(UIButton *)btn;

- (void) setupBackgroundWithIndex;

- (void) setItem: (UIButton *) btn;

- (void) dressUPDown: (int) type itemName:(NSString *) itemName;


-(void)action;

- (void) makeUpdateItemsList: (NSArray *) array atTag: (int)tag;


- (void) removeLock;

@end

@protocol GirlsDelegate

-(void)GirlsViewDidComplete:(Girls *)contoller;

@end