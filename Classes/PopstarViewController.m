//
//  PopstarViewController.m
//  Popstar
//
//  Created by Alexander Morgun on 8/22/11.
//  Copyright 2011 InjoiT.com. All rights reserved.



// 2a79ea27c279e471f4d180b08d62b00a

#import "PopstarViewController.h"

#import "Models.h"
#import "Girl.h"
#import "PopstarAppDelegate.h"

@implementation PopstarViewController

@synthesize start_frame;
@synthesize startScreen, start_bgd, start_button;

@synthesize mainView, main_background, main_model, main_kissing, main_Camera;

@synthesize dressUp;
@synthesize unlockButton;

@synthesize girls = girls;
@synthesize tempImg;

PopstarAppDelegate *app;

short int x2;



// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        // Custom initialization
    }
    return self;
}
-(void)alertMessage:(NSString *)strMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !" message:strMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	ad=[[MGAd alloc] initForInterstitialWithSecret:kAdSecret orientation:UIInterfaceOrientationPortrait];
    [ad showAdsOnViewController:self];
	app = (PopstarAppDelegate*)[[UIApplication sharedApplication] delegate];
	_firstX = 0;
    _firstY = 0;
	x2 = (app.isPad) ? 2 : 1;
    
}


- (NSString *) imageName: (NSString *)name {
	NSString *imageName = (app.isPad) ? [NSString stringWithFormat:@"%@@2x.png", name] : [NSString stringWithFormat:@"%@.png", name];
	return imageName;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.girls = nil;
}


- (void)dealloc {
    [ad stopAds];
    [ad release];
    [mainView release];
    [super dealloc];
}

/*
- (void) resizeInterfaceButton: (UIButton *)button imageName:(NSString *)name {
	[button setFrame:CGRectMake(button.frame.origin.x*x2+120, button.frame.origin.y*x2, button.frame.size.width*x2, button.frame.size.height*x2)];
	[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@@2x.png", name]] forState:UIControlStateNormal];
}
*/

//Main page
- (IBAction) styleNow {
	[app reviewCounter];
	
	if (x2 == 2) {
		[mainView setFrame:CGRectMake(0, 0, 768, 1024)];
		
		[main_background setFrame:CGRectMake(0, 0, 768, 1024)];
		[main_background setImage:[UIImage imageNamed:@"dressup_frame1.png"]];
        [main_kissing setFrame:CGRectMake(80, 800, 100, 100)];
        [main_model setFrame:CGRectMake(595, 800, 100, 100)];
        [main_Camera setFrame:CGRectMake(334, 875, 100, 100)];
	}else{
        [tempImg setHidden:YES];
        [main_background setImage:[UIImage imageNamed:@"backgr_main_ipad.jpg"]];
    }
	
	main_model.exclusiveTouch = YES;
	main_kissing.exclusiveTouch = YES;
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8];
	[startScreen setHidden:YES];
	[mainView setHidden:NO];
	[mainView setAlpha:1];
	[UIView commitAnimations];
	
	startGame = [UIButton buttonWithType:UIButtonTypeCustom];
	startGame.exclusiveTouch = YES;
	[startGame addTarget: self action:@selector(choiceGirl:) forControlEvents:UIControlEventTouchUpInside];
    [startGame setBackgroundImage:[UIImage imageNamed:@"CameraButton1.png"] forState:UIControlEventTouchUpInside];
	[startGame setFrame: CGRectMake(123, 405, 75, 75)];
	[mainView addSubview: startGame];
}


- (int)getCacheMoney{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"money"];
}

- (void)setCacheMoney: (int) money {
    
    [[NSUserDefaults standardUserDefaults] setInteger:money forKey:@"money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	
    //    NSLog(@"money is: %d",[self getCacheMoney]);
}

- (UIImage*)captureView:(UIView *)view bounds:(CGRect)rect{
    img1 = [[UIImage alloc]init];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        UIGraphicsBeginImageContext(CGSizeMake(768, 980));
    else
        UIGraphicsBeginImageContext(CGSizeMake(320, 436));

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, rect);
    [view.layer renderInContext:context];
    img1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img1;
}
-(void)appStart{
    [startGame setHidden:NO];
    self.girls = [[[Girls alloc] init] autorelease];
    self.girls.delegate = self;
    self.girls.number = 1; //wich number have Selena?
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        self.girls.imgFaceImage = ([self captureView:canvas bounds:CGRectMake(0, 0, 768, 980)]);
    else
        self.girls.imgFaceImage = ([self captureView:canvas bounds:CGRectMake(0, 0, 320, 436)]);
        
    dressUp = YES;
    self.girls.imgFaceImage = img1;
    girls.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [OverLay removeFromSuperview];
    [EditView removeFromSuperview];
    [EditView release];
    EditView = nil;
    [self presentModalViewController:self.girls animated:YES];
}

-(void)takePicture{
    [ipcImage takePicture];
}

-(void)primCamera{
    if(ipcImage.cameraDevice == UIImagePickerControllerCameraDeviceFront)
        ipcImage.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    else
        ipcImage.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    
}

-(IBAction)btnCamreraPress:(id)sender{
    [self choiceGirl:sender];
}

- (void) choiceGirl: (UIButton *)btn  {
    [startGame setHidden:YES];
    if(EditView){
        [EditView removeFromSuperview];
        [EditView release];
        EditView = nil;
    }
    
    if(x2 == 2){
        ivTemp1 = [[UIImageView alloc]initWithFrame:CGRectMake(44, 18, 683, 945)]; //overlay
        ivTemp3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 768, 980)]; //border
        ivTemp2 = [[UIImageView alloc]initWithFrame:CGRectMake(445, 98, 100, 115)]; // capture image
        ivTemp3.image = [UIImage imageNamed:@"dressup_frame1.png"];
    }
    else{
        ivTemp1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
        ivTemp2 = [[UIImageView alloc]initWithFrame:CGRectMake(180, 35, 47, 65)];
        
    }
    ivTemp1.image = [UIImage imageNamed:@"OverLayImage.png"];
    [ivTemp1 setUserInteractionEnabled:YES];
    
    
    [ivTemp1 setAlpha:.9];
    UIButton *btnCapture1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCapture1 setFrame:CGRectMake(self.view.frame.size.width-90, 15, 71, 32)];
    [btnCapture1 setBackgroundImage:[UIImage imageNamed:@"primCamera.png"] forState:UIControlStateNormal];
    [btnCapture1 addTarget:self action:@selector(primCamera) forControlEvents:UIControlEventTouchUpInside];
    [ivTemp1 addSubview:btnCapture1];
    
    
    [ivTemp2 setBackgroundColor:[UIColor clearColor]];
    
    ipcImage = [[UIImagePickerController alloc]init];
    ipcImage.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        ipcImage.sourceType = UIImagePickerControllerSourceTypeCamera;

        [ipcImage.cameraOverlayView addSubview:ivTemp1];
        [ipcImage.cameraOverlayView addSubview:ivTemp2];
        if(x2 == 2)
            [ipcImage.cameraOverlayView addSubview:ivTemp3];
        ipcImage.showsCameraControls=NO;
        [ad stopAds];
        //[ad release];
        ad = nil;
        ipcImage.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    else
        [self alertMessage:@"Camera is not available"];
    
    if(x2 == 2)
        theToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 980, 768, 44)];
    else
        theToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 436, 320, 44)];
    
    UIButton *btnCapture = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCapture setFrame:CGRectMake(0, 0, 96, 37)];
    [btnCapture setBackgroundImage:[UIImage imageNamed:@"CameraButton1.png"] forState:UIControlStateNormal];
    [btnCapture addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cameraBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCapture];
    
    UIBarButtonItem *btnFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace  target:nil action:nil];
    
    theToolbar.items = [NSArray arrayWithObjects: btnFlexibleSpace,cameraBarButtonItem,btnFlexibleSpace, nil];
    theToolbar.tintColor = [UIColor blackColor];
    
    [ipcImage.cameraOverlayView addSubview:theToolbar];
    [self presentModalViewController:ipcImage animated:NO];
}

- (UIImage *)croppedImage:(CGRect)bounds image:(UIImage *)image {
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

-(void)EditImage{
    // ivTemp.image = [self croppedImage:[self getCroppedImage:ivTemp.image.size] image:[self rotateImage:ivTemp.image byOrientationFlag:ivTemp.image.imageOrientation]];
    
    if(x2 == 2){
        EditView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
        ivBorder = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 768, 980)];
        canvas = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 980)];
        ivPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 768, 980)];//74, 38, 653, 898
        OverLay = [[UIImageView alloc]initWithFrame:CGRectMake(44, 18, 683, 945)];
        theEditToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 980, 768, 44)];
        [ivBorder setImage:[UIImage imageNamed:@"dressup_frame1.png"]];
        NSLog(@"333333");
    }
    else{
        EditView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        canvas = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 436)];
        ivPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 436)];
        OverLay = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 436)];
        theEditToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 436, 320, 44)];
    }
    [OverLay setAlpha:0.9];
    [EditView setBackgroundColor:[UIColor whiteColor]];

    theEditToolbar.tintColor = [UIColor blackColor];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(0, 0, 62, 32)];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"use.png"] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(appStart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnUse = [[UIBarButtonItem alloc] initWithCustomView:btnDone];
    
    UIButton *btnRetake = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRetake setFrame:CGRectMake(0, 0, 62, 32)];
    [btnRetake setBackgroundImage:[UIImage imageNamed:@"Retake.png"] forState:UIControlStateNormal];
    [btnRetake addTarget:self action:@selector(choiceGirl:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnRetak = [[UIBarButtonItem alloc] initWithCustomView:btnRetake];

    UIBarButtonItem *btnFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace  target:nil action:nil];
    
    theEditToolbar.items = [NSArray arrayWithObjects: btnRetak,btnFlexibleSpace,btnUse, nil];
    
    [canvas addSubview:ivPhoto];
    [EditView addSubview:canvas];
    
    [EditView addSubview:OverLay];
    [EditView addSubview:ivBorder];
    [self.view addSubview:EditView];
    
    [ivPhoto setImage:ivTemp.image];
    [OverLay setImage:ivTemp1.image];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)] autorelease];
    [pinchRecognizer setDelegate:self];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] autorelease];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [canvas addGestureRecognizer:panRecognizer];
    
    [EditView addSubview:theEditToolbar];
}


-(void)scale:(id)sender {
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = ivPhoto.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [ivPhoto setTransform:newTransform];
    
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
}

-(void)move:(id)sender {
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:canvas];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [ivPhoto center].x;
        _firstY = [ivPhoto center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
    [ivPhoto setCenter:translatedPoint];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    ivTemp = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    ivTemp.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    /*if (picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        CGSize imageSize = ivTemp.image.size;
        UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextRotateCTM(ctx, M_PI/2);
        CGContextTranslateCTM(ctx, 0, -imageSize.width);
        CGContextScaleCTM(ctx, imageSize.height/imageSize.width, imageSize.width/imageSize.height);
        CGContextDrawImage(ctx, CGRectMake(0.0, 0.0, imageSize.width, imageSize.height), ivTemp.image.CGImage);
        ivTemp.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImage * flippedImage = [UIImage imageWithCGImage:ivTemp.image.CGImage scale:ivTemp.image.scale orientation:UIImageOrientationLeftMirrored];
        
        ivTemp.image = flippedImage;
    }
     */
    if (picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        ivTemp.image = [UIImage imageWithCGImage:ivTemp.image.CGImage scale:ivTemp.image.scale orientation:UIImageOrientationLeftMirrored];
    }
   
    [picker dismissModalViewControllerAnimated:YES];
    [picker release];
    picker = nil;
    [self EditImage];
}

- (void) deleteGirlsView {
	[self.girls dismissModalViewControllerAnimated:YES];
	self.girls=nil;
	dressUp = NO;
}

-(void)GirlsViewDidComplete:(Girls *)contoller
{
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(deleteGirlsView)];
	[self.girls.view setAlpha:0];
	[UIView commitAnimations];
}


//Second page
- (IBAction)models {
	[app.cameraSound play];
	
    UIViewController *vc=[[UIViewController alloc] init];
	Models *models = [[Models alloc] initWithFrame:self.view.frame controller:vc];
	[vc.view addSubview:models];
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:vc animated:YES];
	[models release];
    [vc release];
}

- (IBAction)startKissingGame {
	KissGame *kiss = [[KissGame alloc] init];
	[kiss.view setFrame:self.view.frame];
	kiss.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:kiss animated:YES];
    [kiss release];
}



@end