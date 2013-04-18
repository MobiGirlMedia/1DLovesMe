//
//  Girls.m
//  Popstar
//
//  Created by Alexander Morgun on 8/22/11.
//  Copyright 2011 InjoiT.com. All rights reserved.
//
/*
 
 */
#import "Girl.h"
#import <QuartzCore/QuartzCore.h>
#import <MobiGirl/MGAd.h>

#define new_width 640
#define new_height 960
#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5

static int bakcgoundCount [3] = {8,				8,			9};
static NSString *category [3] = { @"redcarpet", @"onstage", @"outnabout" };

static NSString *wardrobe[2] = { @"selena", @"justin" };
static NSString *defaultClothes[2][14] = {
	//носки, колгот, колг. с туф., туфли,	сумочки,штаны,		топ,          подтяжки, платья, аксессуары, украшения, жакет,волосы,		очки
    { @"",  @"",	@"",		@"",		@"",	@"2027", @"2029",  @"",     @"",   @"",		@"",	  @"",   @"so2hair",    @"" }, //Selena
	{ @"",  @"",	@"",		@"JOAshoes2@2x",@"",	@"default-man-outfit", @"JOAtop2@2x",   @"",     @"",	  @"",		@"",	  @"JOAjacket2@2x",   @"Jhair3@2x",    @"" } //Miley
};


short int categoryIndex = 14;

BOOL isDress = NO;
BOOL isVisibleUnderwear = YES;
BOOL isPantyhose = NO;

BOOL isHidden = NO;

short int x2;

PopstarAppDelegate *app;



@interface Girls (UtilityMethods)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end


@implementation Girls

//@synthesize imageScrollView;
@synthesize number;
@synthesize delegate;
@synthesize ivFaceImage;

- (id)init {
    
    self = [super init];
    if (self)
    {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}


- (void) playBuy {
	[buy play];
}


- (NSString *) imageName: (NSString *)name {
	NSString *imageName = (x2 == 2) ? [NSString stringWithFormat:@"%@@2x", name] : [NSString stringWithFormat:@"%@", name];
	return imageName;
}

-(UIImage *)makeRoundedImage:(UIImage *) image radius: (float) radius;
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
    if(x2 == 2)
        ivFaceImage = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 0, 653, 899)];
    else
        ivFaceImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 640, 872)];
    
    ivFaceImage.image = self.imgFaceImage;
    
    
    
	app = (PopstarAppDelegate*)[[UIApplication sharedApplication] delegate];
	x2 = (app.isPad) ? 2 : 1;
	
    if (app.isPad) {
    }else{
        ad=[[MGAd alloc] initForInterstitialWithSecret:kAdSecret orientation:UIInterfaceOrientationPortrait];
    }
    [ad showAdsOnViewController:self];
    
	//Frame imag
	UIImageView *frame = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
	[self.view addSubview:frame];
	
	//Place holder for iPhone screen
	platform = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[self.view addSubview:platform];
	[platform release];
	
	if (x2 == 2) {
		[platform setFrame:CGRectMake(64, 32, 640, 960)];
		[frame setImage:[UIImage imageNamed:@"dressup_frame1.png"]];
	}
	[frame release];
	
    
    
    imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320*x2, 480*x2)];
    imageScrollView.scrollEnabled = YES;
    imageScrollView.bounces = YES;
    imageScrollView.bouncesZoom = YES;
    imageScrollView.delaysContentTouches = YES;
    imageScrollView.canCancelContentTouches = YES;
    imageScrollView.opaque = YES;
    imageScrollView.clearsContextBeforeDrawing = YES;
    imageScrollView.autoresizesSubviews = YES;
    imageScrollView.userInteractionEnabled = YES;
    imageScrollView.multipleTouchEnabled = YES;
    imageScrollView.delegate = self;
    [platform addSubview:imageScrollView];
    
	NSLog(@"ImageScrollView retainCount = %d", imageScrollView.retainCount);
	[imageScrollView release];
	NSLog(@"ImageScrollView retainCount = %d", imageScrollView.retainCount);
    
    // Initialization code.
    modelView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, new_width, new_height)];
    
    [modelView addSubview:ivFaceImage];
    
    if(x2 == 2){
        backImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 10, new_width, new_height)];
    }else
        backImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, new_width, new_height)];
    
    
	[backImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[self imageName:@"default-screen"] ofType:@"png"]]];
    [modelView addSubview: backImageView];
    //[modelView setBackgroundColor:[UIColor blackColor]];
	[backImageView release];
    
    
    
    girlIndex = self.number - 1;
    //    originalGirl = girlIndex;
    
	
    //	UIImageView *boy = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self imageName:[NSString stringWithFormat:@"boy%d", number]]]];
	boy = [[UIImageView alloc] initWithImage:
						[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"boy%d@2x", number] ofType:@"png"]]];
	[boy setFrame:CGRectMake(0, 5*x2, new_width, new_height)];
	[modelView addSubview:boy];
	[boy release];
	
    
	for (int i=0; i<14; i++) {
		boyClothes[i] = [[UIImageView alloc] initWithFrame:CGRectMake(0*x2, 5*x2, new_width, new_height)];
		[modelView addSubview:boyClothes[i]];
		[boyClothes[i] release];
	}
    
	girl = [[UIImageView alloc] init];
    girl.image = [UIImage imageNamed:[self imageName:[NSString stringWithFormat:@"girl%d", number]]];
    NSLog(@"ALOC     %@",[NSString stringWithFormat:@"girl%d", number]);
    
    if(x2 == 1)
        [girl setFrame:CGRectMake(95.5, (8*x2)-1, new_width, new_height)];
    else
        [girl setFrame:CGRectMake(100, 8*x2, new_width, new_height)];
    
	[modelView addSubview:girl];
	
	
    
    
	wearedItems = [[NSMutableArray alloc] init];//WithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:wardrobe[originalGirl]]];
	boyWearedItems = [[NSMutableArray alloc] init];
	[self clothingOfGirl];
	
    [imageScrollView addSubview: modelView];
    
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    items = [[NSMutableDictionary alloc] initWithDictionary: [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/items.plist", documentsDirectory]]];
    
    controls = [[NSMutableArray alloc] init];
    
    //scroll for items
    UIImage * slImg = [UIImage imageNamed: [self imageName:@"sidebar"]];
    UIImageView *sidebar = [[UIImageView alloc] initWithFrame: CGRectMake(259*x2, 0*x2, slImg.size.width, slImg.size.height)];
    sidebar.image = slImg;
    [platform addSubview: sidebar];
    [controls addObject:sidebar];
    [sidebar release];
    
	
	UIImage * cImg = [UIImage imageNamed: [self imageName:@"camera"]];
    UIButton *cameraButton = [UIButton buttonWithType: UIButtonTypeCustom];
	cameraButton.exclusiveTouch = YES;
    cameraButton.frame = CGRectMake(6*x2, 440*x2, cImg.size.width, cImg.size.height);
    [cameraButton setImage: cImg forState: UIControlStateNormal];
    [cameraButton addTarget: self action:@selector(makePhoto) forControlEvents:UIControlEventTouchUpInside];
    [platform addSubview: cameraButton];
	[controls addObject:cameraButton];
    
    UIImage * mImg = [UIImage imageNamed: [self imageName:@"music"]];
    UIButton *musicButton = [UIButton buttonWithType: UIButtonTypeCustom];
    musicButton.exclusiveTouch = YES;
	musicButton.frame = CGRectMake(6*x2, 354*x2, mImg.size.width, mImg.size.height);
    [musicButton setImage: mImg forState: UIControlStateNormal];
    [musicButton addTarget: self action:@selector(showMucisPage) forControlEvents:UIControlEventTouchUpInside];
    [platform addSubview: musicButton];
	[controls addObject:musicButton];
	
	//revert button
    UIImage * resetImg = [UIImage imageNamed: [self imageName:@"resetbutton"]];
    UIButton *resetButton = [UIButton buttonWithType: UIButtonTypeCustom];
    resetButton.exclusiveTouch = YES;
	resetButton.frame = CGRectMake(8*x2, 396*x2, resetImg.size.width, resetImg.size.height);
    [resetButton setImage: resetImg forState: UIControlStateNormal];
    [resetButton addTarget: self action:@selector(revertClothes) forControlEvents:UIControlEventTouchUpInside];
    [platform addSubview: resetButton];
    [controls addObject:resetButton];
    
    //back button
    UIImage * bImg = [UIImage imageNamed: [self imageName:@"backbutton"]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setExclusiveTouch:YES];
	[backButton setImage:bImg forState:UIControlStateNormal];
    [backButton addTarget: self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame: CGRectMake(6*x2, 6*x2, bImg.size.width, bImg.size.height)];
    [platform addSubview: backButton];
	[controls addObject: backButton];
	
	for (int i=0; i<2; i++) {
		
		
		NSString *imgName = [self imageName:[NSString stringWithFormat: @"wardrobe%d",i+1]];
		UIImage *wImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:@"png"]];
		wardrobeBtn[i] = [UIButton buttonWithType:UIButtonTypeCustom];
		wardrobeBtn[i].exclusiveTouch = YES;
		[wardrobeBtn[i] setBackgroundImage: wImg forState:UIControlStateNormal];
		
		wardrobeBtn[i].tag = i;
		[wardrobeBtn[i] addTarget: self action:@selector(switchWardrobe:) forControlEvents:UIControlEventTouchUpInside];
		[wardrobeBtn[i] setFrame: CGRectMake(5*x2, (304-(i*44))*x2, wImg.size.width*x2, wImg.size.height*x2)]; //+3 to height
		[platform addSubview: wardrobeBtn[i]];
		[controls addObject:wardrobeBtn[i]];
	}
	
	
	for (int i=0; i<4; i++) {
		UIImage *ctImg = [UIImage imageNamed:[self imageName:[NSString stringWithFormat: @"category%d",i+1]]];
		categoryBtn[i] = [UIButton buttonWithType:UIButtonTypeCustom];
		categoryBtn[i].exclusiveTouch = YES;
		[categoryBtn[i] setImage:ctImg forState:UIControlStateNormal];
		categoryBtn[i].tag = i;
		[categoryBtn[i] addTarget: self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
		[categoryBtn[i] setFrame: CGRectMake(265*x2, (2+(52*i))*x2, ctImg.size.width, ctImg.size.height)];
		[platform addSubview: categoryBtn[i]];
		[controls addObject:categoryBtn[i]];
	}
	
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(259*x2, 205*x2, 61*x2, 276*x2)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = YES;
    scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    scrollView.delaysContentTouches = YES;//?!
    [platform addSubview:scrollView];
	[controls addObject:scrollView];
    [scrollView release];
    
    
    buy = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"BuySound" ofType:@"mp3"]] error:nil];
    [buy setVolume:0.7];
    photoSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"camera" ofType:@"mp3"]] error:nil];
    [photoSound setVolume:0.5];
    putOnSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"puton clothes" ofType:@"mp3"]] error:nil];
	[putOnSound setVolume:0.5];
    
	
	[self switchWardrobe:wardrobeBtn[originalGirl]];
    
    
    // set the tag for the image view
    [modelView setTag:ZOOM_VIEW_TAG];
    
    // add gesture recognizers to the image view
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    [twoFingerTap setNumberOfTouchesRequired:2];
    
    [modelView addGestureRecognizer:singleTap];
    [modelView addGestureRecognizer:doubleTap];
    [modelView addGestureRecognizer:twoFingerTap];
    
    [singleTap release];
    [doubleTap release];
    [twoFingerTap release];
    
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    minimumScale = [imageScrollView frame].size.width  / [modelView frame].size.width;
    [imageScrollView setMinimumZoomScale:minimumScale];
    [imageScrollView setZoomScale:minimumScale];
	
	[modelView release];
}


-(void)viewDidUnload
{
    [super viewDidUnload];
    imageScrollView = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self timerInitialization];
}


- (void) clothingOfGirl {
	BOOL loaded = NO;
	
    
    
	for (int i=0; i<14; i++) {
		NSString *girlStr, *boyStr;
        
		if (loaded) {
            //			girlStr = [wearedItems objectAtIndex:i];
		}
		else {
			girlStr = defaultClothes[originalGirl][i];
			boyStr = defaultClothes[1][i];
            [wearedItems addObject:girlStr];
			[boyWearedItems addObject:boyStr];
		}
        
		UIImage *girlItem = (girlStr == @"")? nil : [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                                                      pathForResource:[self imageName:girlStr] ofType:@"png"]];
		UIImage *boyItem = (boyStr == @"")? nil : [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                                                    pathForResource:boyStr ofType:@"png"]];
		
		boyClothes[i].image = boyItem;
		
		girlClothes[i] = [[UIImageView alloc] initWithFrame:CGRectMake(100, 8*x2, new_width, new_height)];
		girlClothes[i].image = girlItem;
		[modelView addSubview:girlClothes[i]];
		[girlClothes[i] release];
	}
	boyClothes[12].hidden = YES;
	if (loaded) {
		NSLog(@"load saved items");
	}
}


- (void) timerInitialization {
    //	@synchronized(self) {
    //		if (dissapearTimer) {
    //			[dissapearTimer invalidate];
    //			return;
    //		}
    //		dissapearTimer = [NSTimer scheduledTimerWithTimeInterval: 15.0 target: self selector: @selector(hideControls) userInfo: nil repeats: NO]; //Some problem with retainCount of Girl class 
    //	}
	isHidden = NO;
}

- (void) hideControls {
    //	[dissapearTimer invalidate];
    //    dissapearTimer = nil;
	
	isHidden = YES;
	
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration: .5];
    
    for (UIView *tmp in controls) {
        tmp.alpha = 0.0;
    }
    [backImageView setAlpha:1];
    //[ivFaceImage setAlpha:0];
	[UIView commitAnimations];
}

- (void) showControls {
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration: .5];
	[UIView setAnimationDelegate: self];
    //	[UIView setAnimationDidStopSelector: @selector(timerInitialization)];
	
    for (UIView *tmp in controls) {
        tmp.alpha = 1.0;
    }
	isHidden = NO;
	//[ivFaceImage setAlpha:1];
	[UIView commitAnimations];
}


- (void) showMucisPage {
	[putOnSound play];
	
    MusicPage *musicPage = [[MusicPage alloc] initWithFrame:CGRectMake(0, 0, 320*x2, 480*x2)];
	musicPage.alpha = 0;
	[platform addSubview:musicPage];
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8];
	[musicPage setAlpha:1];
	[UIView commitAnimations];
    
    [musicPage release];
}

-(void) pickACover {
	int w = (x2 == 2) ? 768 : 320;
	int h = (x2 == 2) ? 1024 : 480;
	
	ChoiceOfCover *choiceOfCover = [[ChoiceOfCover alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    //choiceOfCover.ivFaceImageData = UIImagePNGRepresentation(ivFaceImage.image);
    
	[self.view addSubview:choiceOfCover];
    [choiceOfCover release];
}


- (void) makePhoto {
	[photoSound play];
    
    platform.userInteractionEnabled = NO;
	backImageView.alpha = 0;
	
    [self hideControls];
    
	SavePhoto *savePhoto = [SavePhoto alloc];
    [imageScrollView setZoomScale:minimumScale];
	[savePhoto windowOfLevel:platform withCover:NO];
	[savePhoto release];
    
    app.myPhoto = [self.imgFaceImage copy];
    
	[self pickACover];
    
	backImageView.alpha = 1;
	[self showControls];
	platform.userInteractionEnabled = YES;
}



- (void) revertClothes {
	[putOnSound play];
    
	girl.image = [UIImage imageNamed:[self imageName:[NSString stringWithFormat:@"girl%d", number]]];
    NSLog(@"REVERT     %@",[NSString stringWithFormat:@"girl%d", number]);
    for (int i=0; i<14; i++) {
        NSString *str1 = defaultClothes[originalGirl][i];
        NSString *str2 = defaultClothes[1][i];
		
        if([str1 isEqualToString: @""])
            girlClothes[i].image = nil;
        else {
            // UIImage *image = [UIImage imageNamed:[self imageName:str1]];
			UIImage *image = [UIImage imageWithContentsOfFile:
							  [[NSBundle mainBundle] pathForResource:str1 ofType:@"png"]];
			girlClothes[i].image = image;
        }
		
		if([str2 isEqualToString: @""])
            boyClothes[i].image = nil;
        else {
			UIImage *image = [UIImage imageWithContentsOfFile:
							  [[NSBundle mainBundle] pathForResource:str2 ofType:@"png"]];
            boyClothes[i].image = image;
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex >= 1) {
		[app showHUD];
		      
		if ([app internetConnected]) {
            if (buttonIndex == 2) {
                [[MKStoreManager sharedManager] buyFeatureARestore];
                NSLog(@"Restore Now...");
            } else {
                [[MKStoreManager sharedManager] buyFeatureA];
            }
			[FlurryAnalytics logEvent:@"User want to get more Style Dollars per 0.99$"];
		}
		else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet connection"
															message:@"Internet access is unavailable, please go into settings to connect to the Internet."
														   delegate:self
												  cancelButtonTitle:@"OK"
												  otherButtonTitles: nil];
			[alert show];
			[alert release];
			
			[app hideHUD];
		}
	}
    
}


#pragma mark Back Routines

- (void) setupBackgroundWithIndex {
	[putOnSound play];
	
	// ToDo: занилить backIndex при смене категории
    
    if ( categoryIndex <  3) {
		if (!isHidden) {
			if (backIndex >= bakcgoundCount[categoryIndex]) {
				backIndex = 0;
			}
			backIndex++;
			
			NSString *p = [NSString stringWithFormat:@"%@%d",category[categoryIndex], backIndex];
            //			backImageView.image = [UIImage imageNamed:[self imageName:p]];
			backImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource: [self imageName:p] ofType:@"png"]];
		}
    }
	
	//[self action];
}

-(void)setSkinColor:(UIButton *)btn{
    if (girlIndex == 1 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"time"]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"1D Pack!"
														message:@"Unlock The 1D Boys!"
													   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Buy",@"Restore", nil];
		[alert setTag: 1];
		[alert show];
		[alert release];
	}else{
        boy.image = [UIImage imageNamed:[NSString stringWithFormat:@"girlskin%d.png", btn.tag]];
        NSLog(@"%@",[NSString stringWithFormat:@"girlskin%d.png", btn.tag]);
    }
}

-(void)setSkinColor1:(UIButton *)btn{
    girl.image = [UIImage imageNamed:[NSString stringWithFormat:@"girlq%d.png", btn.tag]];
    NSLog(@"%@",[NSString stringWithFormat:@"girlq%d.png", btn.tag]);
}

#pragma mark === Dress up part ===

- (void) selectCategory:(UIButton *)btn {
	[putOnSound play];
	
	backIndex = 0;
	categoryIndex = btn.tag;
    
	[self setupBackgroundWithIndex];
    //	[self action];
	
	for (UIButton *b in [scrollView subviews]) {
		[b removeFromSuperview];
	}
	
	[scrollView setContentOffset:CGPointMake(0, 0)];
	
    
    if(btn.tag == 3 || btn.tag == 6){
        
        short int heightOfColumn = 10*x2;
        if(btn.tag == 6){
            for(int i = 1;i<6;i++){
                UIButton *buttonItm = [UIButton buttonWithType:UIButtonTypeCustom];
                buttonItm.exclusiveTouch = YES;
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"skin%d.png",i]];
                [buttonItm addTarget:self action:@selector(setSkinColor:) forControlEvents:UIControlEventTouchUpInside];
                [buttonItm setFrame:CGRectMake(5, heightOfColumn, scrollView.frame.size.width - 10, 50*x2)];
                [buttonItm setBackgroundImage: image forState:UIControlStateNormal];
                [buttonItm setTag:i];
                [scrollView addSubview:buttonItm];
                heightOfColumn+=55*x2;
                
                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"time"]) {
                    if (girlIndex == 1) {
                        UIImage *lock_img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[self imageName:@"lock"] ofType:@"png"]];
                        UIImageView *priceTicket = [[UIImageView alloc] initWithImage:lock_img];
                        
                        //Опередляем смещение замка
                        //          int dif = (buttonItm.frame.size.width*x2 - 59*x2)/2;
                        
                        int x = 36*x2;
                        int y = buttonItm.frame.size.height-lock_img.size.height*x2;
                        
                        [priceTicket setFrame:CGRectMake(x, y, lock_img.size.width*x2, lock_img.size.height*x2)];
                        [buttonItm addSubview:priceTicket];
                        
                        [priceTicket release];
                    }
                }
            }
        }else{
            for(int i = 1;i<4;i++){
                UIButton *buttonItm = [UIButton buttonWithType:UIButtonTypeCustom];
                buttonItm.exclusiveTouch = YES;
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"heart%d.png",i]];
                [buttonItm addTarget:self action:@selector(setSkinColor1:) forControlEvents:UIControlEventTouchUpInside];
                [buttonItm setFrame:CGRectMake(5, heightOfColumn, scrollView.frame.size.width - 10, 50*x2)];
                [buttonItm setBackgroundImage: image forState:UIControlStateNormal];
                [buttonItm setTag:i];
                [scrollView addSubview:buttonItm];
                heightOfColumn+=55*x2;
            }
        }
        scrollView.contentSize = CGSizeMake(0, heightOfColumn);
    }else{
        
        //Items list
        NSDictionary *categoryForGirl = [[NSDictionary alloc] initWithDictionary:[items objectForKey:wardrobe[girlIndex]]];
        
        //NSLog(@"CategoryForGirl: %@", categoryForGirl);
        
        if (itemsList) {
            [itemsList removeAllObjects];
            [itemsList release];
            itemsList = nil;
        }
        itemsList = [[NSMutableArray alloc] initWithArray:[categoryForGirl objectForKey:category[categoryIndex]]];
        
        [categoryForGirl release];
        
        short int heightOfColumn = 5*x2;
        
        //Add items to slider
        for (int i=0; i<[itemsList count]; i++) {
            NSArray *curItem = [itemsList objectAtIndex:i];
            
            NSString *str = [NSString stringWithFormat:@"%@small",[curItem objectAtIndex:0]];
            
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[self imageName:str] ofType:@"png"]];
            
            NSLog(@"%@small.png",[curItem objectAtIndex:0]);
            
            //		UIImage *image = [UIImage imageNamed:[self imageName:str]];
            
            UIButton *buttonItm = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonItm.exclusiveTouch = YES;
            [buttonItm addTarget:self action:@selector(setItem:) forControlEvents:UIControlEventTouchUpInside];
            [buttonItm setFrame:CGRectMake((61-image.size.width)*x2/2, heightOfColumn, image.size.width*x2, image.size.height*x2)];
            
            [buttonItm setBackgroundImage: image forState:UIControlStateNormal];
            [buttonItm setTag:i];
            [scrollView addSubview:buttonItm];
            
            if (image) heightOfColumn += (buttonItm.frame.size.height + 24*x2);
            
            //отображение изображения lock
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"time"]) {
                if (girlIndex == 1) {
                    UIImage *lock_img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[self imageName:@"lock"] ofType:@"png"]];
                    UIImageView *priceTicket = [[UIImageView alloc] initWithImage:lock_img];
                    
                    //Опередляем смещение замка
                    //          int dif = (buttonItm.frame.size.width*x2 - 59*x2)/2;
                    
                    int x = 36*x2;
                    int y = buttonItm.frame.size.height-lock_img.size.height*x2;
                    
                    [priceTicket setFrame:CGRectMake(x, y, lock_img.size.width*x2, lock_img.size.height*x2)];
                    [buttonItm addSubview:priceTicket];
                    
                    [priceTicket release];
                }
            }
        }
        scrollView.contentSize = CGSizeMake(61*x2, heightOfColumn-7*x2);
	}
}


- (void) eraseOfCategory {
    //	backImageView.image = [UIImage imageNamed:[self imageName:@"default-screen"]];
	backImageView.image = [UIImage imageWithContentsOfFile:
						   [[NSBundle mainBundle] pathForResource: [self imageName:@"default-screen"] ofType:@"png"]];
    
    for (UIButton *b in [scrollView subviews]) {
        [b removeFromSuperview];
    }
}


- (void) switchWardrobe: (UIButton *) btn {
	[putOnSound play];
    
    NSString *strImg;
    UIImage *npImg;
    if(btn.tag == 1){
        strImg= [self imageName:@"category41"];
        npImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:strImg ofType:@"png"]];
        [categoryBtn[3] setTag:6];
        [categoryBtn[3] setImage:[UIImage imageNamed:@"category41.png"] forState:UIControlStateNormal];
        [scrollView setFrame:CGRectMake(259*x2, 205*x2, 61*x2, 276*x2)];
    }else{
        strImg= [self imageName:@"category4"];
        npImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:strImg ofType:@"png"]];
        [categoryBtn[3] setTag:3];
        [categoryBtn[3] setImage:[UIImage imageNamed:@"category4.png"] forState:UIControlStateNormal];
        [scrollView setFrame:CGRectMake(259*x2, 205*x2, 61*x2, 276*x2)];
    }
    if(x2==2)
        [categoryBtn[3] setFrame: CGRectMake(265*x2, (2+(52*3))*x2, npImg.size.width*2, npImg.size.height*2)];
    
	//Выбранный гардероб помечается другим изображением
	NSString *temp;
	for (int i=0; i<2; i++) {
		temp = [self imageName:[NSString stringWithFormat: @"wardrobe%d",i+1]];
		UIImage *npImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:temp ofType:@"png"]];
		[wardrobeBtn[i] setBackgroundImage:npImg forState:UIControlStateNormal];
	}
	
	temp = [self imageName:[NSString stringWithFormat: @"wardrobe%d_o", btn.tag+1]];
	UIImage *pImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:temp ofType:@"png"]];
	[wardrobeBtn[btn.tag] setBackgroundImage:pImg forState:UIControlStateNormal];
	
	currentItemsArray = (btn.tag) ? boyWearedItems : wearedItems;
	
    girlIndex = btn.tag;
    categoryIndex = 14;
    
    [self eraseOfCategory];
    //	[self action];
}


-(void)back
{
	[putOnSound play];
	
	//For new update
    //	[[NSUserDefaults standardUserDefaults] setObject:wearedItems forKey:wardrobe[originalGirl]];
    //	[[NSUserDefaults standardUserDefaults] synchronize];
    [self.delegate GirlsViewDidComplete:self];
}


#pragma Dress up function
- (void) setItem: (UIButton *) btn {
	NSMutableArray *curItem = [itemsList objectAtIndex:btn.tag];
	
    //	[self action];
    
    //NSLog(@"Нажали на итем");
    
	[putOnSound play];
    
	
	//Check out unlock all for Justin
	if (girlIndex == 1 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"time"]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"1D Pack!"
														message:@"Unlock The 1D Boys!"
													   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Buy",@"Restore", nil];
		[alert setTag: 1];
		[alert show];
		[alert release];
	}
	else {
		short int type = [[curItem objectAtIndex:1] intValue];
		NSString *itemName = [curItem objectAtIndex:0];
		NSLog(@"Имя одежды которая добавляется в массив: %@", itemName);
		[self dressUPDown:type itemName:itemName];
	}
}


- (UIImage *) getDefaultClothes: (int) type {
    if (defaultClothes[girlIndex][type]!=@"") {
		NSString *imageName = (girlIndex) ? defaultClothes[girlIndex][type] : [self imageName: defaultClothes[girlIndex][type]];
		return [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
    } else return nil;
}


- (void) eraseLayers: (int) idx,... {
    va_list args;
    va_start(args, idx);
    int i;
    for (i=idx; i!=-1; i=va_arg(args, int)) {
		if (girlIndex)
			boyClothes[i].image = nil;
		else
			girlClothes[i].image = nil;
		
		[currentItemsArray replaceObjectAtIndex:i withObject:@""];
        va_end(args);
    }
}

//Filter of layers
- (void) fillingLayers: (int) idx,... {
    va_list args;
    va_start(args, idx);
    int i;
    for (i=idx; i!=-1; i=va_arg(args, int)) {
        
		if (!girlIndex) { //if girl, girlClothes == 0
			if (girlClothes[i].image==nil) {
				girlClothes[i].image = [self getDefaultClothes:i];
				
				if (i==5 && (girlClothes[1].image!=nil || girlClothes[2].image!=nil || girlClothes[8].image!=nil) && girlClothes[2].image != [UIImage imageNamed:[self imageName: @"ks4"]])
					
					girlClothes[i].image = nil;
			}
		}
		else { //if boy, create next condition for put off clothes that've repeat
			if (boyClothes[i].image==nil) {
				boyClothes[i].image = [self getDefaultClothes:i];
			}
		}
		
        va_end(args);
    }
}

//Removal of clothes
- (void) dressUPDown: (int) type itemName:(NSString *) itemName {
	UIImageView *currentClothes = (girlIndex == 0) ? girlClothes[type] : boyClothes[type];
	
    //	if (girlIndex)
    itemName = [NSString stringWithFormat:@"%@@2x", itemName];
        
    if(![itemName isEqualToString: [currentItemsArray objectAtIndex:type]]) {
		[currentItemsArray replaceObjectAtIndex:type withObject:itemName];
		
        currentClothes.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:itemName ofType:@"png"]];
        
        //UP
        switch (type) {
            case 0:
                [self eraseLayers:1,2,3,-1];
                [self fillingLayers:5,-1];
                break;
            case 1:
                [self eraseLayers:2,5,0,-1];
                if(girlClothes[3].image == [UIImage imageNamed:[self imageName:@"ks4"]]) {
                    [self eraseLayers:3,-1];
                }
                break;
            case 2:
                [self eraseLayers:0,1,3,-1];
                [self eraseLayers:5,-1];
				if ([itemName rangeOfString:@"ks4"].location != NSNotFound) {
					[self eraseLayers:1,-1];
                    girlClothes[5].image = [self getDefaultClothes:5];
				}
                break;
            case 3:
                [self eraseLayers:2,-1];
                //                [self fillingLayers:5,-1];
                
                break;
                
            case 5:
                //                if (!girlIndex)
				[self eraseLayers:7,8,-1];
                [self fillingLayers:6,-1];
                break;
            case 6:
                //                if (!girlIndex)
                [self eraseLayers:8,-1];
                [self fillingLayers:5,-1];
                break;
                //поддтяжки
            case 7:
                [self eraseLayers:5,8,-1];
                [self fillingLayers:5,6,-1];
                break;
            case 8:
                [self eraseLayers:5,6,7,-1];
                break;
                
        }
    } else {
        //DOWN
        currentClothes.image = nil;
		[currentItemsArray replaceObjectAtIndex:type withObject:@""];
		
        switch (type) {
            case 1:
            case 2:
                [self fillingLayers:5,-1];
                break;
            case 5:
				[self fillingLayers:5,-1];
            case 6:
            case 12:
                [self fillingLayers:type,-1];
                break;
            case 8:
                [self fillingLayers:5,6,-1];
                break;
        }
    }
}



- (void) makeUpdateItemsList: (NSArray *) array atTag: (int)tag {
    NSMutableArray *arrayOfItem = [[NSMutableArray alloc] initWithArray:array];
    [arrayOfItem replaceObjectAtIndex:2 withObject:@"1"];
    NSArray *_arrayOfItem = [NSArray arrayWithArray:arrayOfItem];
    [arrayOfItem release];
	
	//NSLog(@"araryOfItems: %@", _arrayOfItem);
    
    [itemsList replaceObjectAtIndex:tag withObject:_arrayOfItem]; //список итемcов для какой-то категории
    
	NSMutableDictionary *itemsListForCategory = [NSMutableDictionary dictionaryWithDictionary:[items objectForKey:wardrobe[girlIndex]]];
	[itemsListForCategory setObject:itemsList forKey:category[categoryIndex]];
	[items setObject:itemsListForCategory forKey:wardrobe[girlIndex]];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/items.plist", [paths objectAtIndex:0]];
	
	if ([items writeToFile:documentsDirectory atomically:YES]) {
        //		NSLog(@"items.plist успешно перезаписан");
	}
	else {
		[FlurryAnalytics logEvent:[NSString stringWithFormat:@"User got some problems with item buy"]];
        //		NSLog(@"items.plist не перезаписан");
	}
}



#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [imageScrollView viewWithTag:ZOOM_VIEW_TAG];
}

-(void)action
{
    if (((UIView *)[controls objectAtIndex:0]).alpha != 1.0) {
		[self showControls];
	}
    /*	else {
     [self timerInitialization];
     }
     */
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView1 withView:(UIView *)view atScale:(float)scale {
    [scrollView1 setZoomScale:scale+0.01*x2 animated:NO];
    [scrollView1 setZoomScale:scale animated:NO];
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
	if(CGRectContainsPoint(modelView.frame, [gestureRecognizer locationInView:platform])){
        [self setupBackgroundWithIndex];
    }
    //	[self action];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    /*float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
	 CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
	 [imageScrollView zoomToRect:zoomRect animated:YES];*/
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}


- (void)dealloc {
	[super dealloc];
	[ad stopAds];
    //[ad release];
	if (buy) {
		if (buy.isPlaying) [buy stop];
		[buy release];
	}
    if (photoSound) {
		if (photoSound.isPlaying) [photoSound stop];
		[photoSound release];
	}
	if (putOnSound) {
		if (putOnSound.isPlaying) [putOnSound stop];
		[putOnSound release];
	}
	
	[itemsList release]; //?? !! осторожно
	[items release];
	
	[wearedItems release];
	[boyWearedItems release];
	
	[controls release];
    
    //	self = nil;
}

#pragma mark - Purchase methods

- (void) removeLock {
	for (UIButton *b in [scrollView subviews]) {
        //		UIImageView *ticket = [[b subviews] objectAtIndex:1];
        //		NSLog(@"ticket %@", ticket);
        //		UIImageView *ticket2 = [[b subviews] objectAtIndex:0];
        //		NSLog(@"ticket2 %@", ticket2);
		[b removeFromSuperview];
        //		[ticket removeFromSuperview];
	}
}


@end