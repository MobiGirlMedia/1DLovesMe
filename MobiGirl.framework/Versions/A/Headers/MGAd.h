//
//  MGAd.h
//  mobigirl
//
//  Created by Shashank Patel on 13/01/12.
//  Copyright (c) 2012 shashankpatel@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAdTypeBanner 0
#define kAdTypeInterstitial 1
#define kAdTypeTerms 2

#define MGSize_iPad_Landscape CGSizeMake(1024, 96)
#define MGSize_iPad_Portrait CGSizeMake(768, 96)
#define MGSize_iPhone_Landscape CGSizeMake(480, 52)
#define MGSize_iPhone_5_Landscape CGSizeMake(568, 52)
#define MGSize_iPhone_Portrait CGSizeMake(320, 70)

typedef enum{
    MGBannerSizePortrait,
    MGBannerSizeLandscape
} MGBannerSize;

@class MGAd;

@protocol MGAdDelegate

-(void) mobiGirlWillPresentInterstitialAd:(MGAd*) adObj;
-(void) mobiGirlDidPresentInterstitialAd:(MGAd*) adObj;
-(void) mobiGirlWillDismissInterstitialAd:(MGAd*) adObj;
-(void) mobiGirlDidDismissInterstitialAd:(MGAd*) adObj;

-(void) mobiGirlWillPresentBannerAd:(MGAd*) adObj;
-(void) mobiGirlDidPresentBannerAd:(MGAd*) adObj;
-(void) mobiGirlWillDismissBannerAd:(MGAd*) adObj;
-(void) mobiGirlDidDismissBannerAd:(MGAd*) adObj;

-(void) mobiGirlFailedToGetAds:(MGAd*) adObj;

@end

@interface MGAd : NSObject{
    int adType;
    NSString *secret;
    NSString *current_ads_id;
    CGRect adFrame;
    BOOL finalized;
    NSObject<MGAdDelegate> *delegate;
}

@property(nonatomic,retain) NSString *secret;
@property(nonatomic,retain) NSString *current_ads_id;
@property(nonatomic,assign) UIViewController *baseViewController;
@property BOOL finalized;
@property(nonatomic,assign) NSObject<MGAdDelegate> *delegate;

+(BOOL) isPaused;
+(void) setPaused:(BOOL) _paused;

-(UIInterfaceOrientation) interfaceOrientation;

-(id) initForBannerWithSecret:(NSString*) _secret origin:(CGPoint) origin orientation:(UIInterfaceOrientation) _orientation;
-(id) initForInterstitialWithSecret:(NSString*) _secret orientation:(UIInterfaceOrientation) _orientation;
-(id) initForTermsWithSecret:(NSString*) secret  orientation:(UIInterfaceOrientation) _orientation;

-(void) showAdsOnViewController:(UIViewController*) vc;
-(void) showTermsOnViewController:(UIViewController*) vc;

-(void) stopAds;
+(NSString*) appSecret;

@end
