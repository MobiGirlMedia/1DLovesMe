//
//  KissGame.m
//  Biber
//
//  Created by Alexander Morgun on 3/17/12.
//  Copyright (c) 2012 InjoiT.com. All rights reserved.
//

#import "KissGame.h"

@implementation KissGame

@synthesize kissSound,sound;

UIImageView *justin;

short int x2;


- (NSString *) imageName: (NSString *)name {
	NSString *imageName = (x2 == 2) ? [NSString stringWithFormat:@"%@@2x.png", name] : [NSString stringWithFormat:@"%@.png", name];
	return imageName;
}


-(void) dealloc{
    self.kissSound=nil;
    [super dealloc];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    ad=[[MGAd alloc] initForInterstitialWithSecret:kAdSecret orientation:UIInterfaceOrientationPortrait];
    [ad showAdsOnViewController:self];
    
    x2 = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? 1 : 2;
    
	NSLog(@"=====>>>>> %d",x2);
    
    NSString *backgrName = [self imageName: @"GameBG"];
	if (x2 == 2) {
		backgrName = @"GameBGiPad";
	}
	
    NSString *filePath=[[NSBundle mainBundle] pathForResource: @"win" ofType:@"mp3"];
    
    //NSData *data=[NSData dataWithContentsOfFile:filePath];
    
//    self.kissSound = [[[AVAudioPlayer alloc] initWithData:data error:nil] autorelease];
	self.kissSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil] autorelease];
	kissSound.numberOfLoops = 0;
	
	[kissSound play];
    
	UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgrName]];
	//[background setFrame:CGRectMake(0, 0, background.image.size.width, background.image.size.height)];
    [background setFrame:self.view.frame];
	[self.view addSubview:background];
	[background release];
	
	justin = [[UIImageView alloc] init];
	[justin setImage:[UIImage imageNamed:[self imageName: @"justin"]]];
    
    [justin setFrame:CGRectMake(82*x2, 89*x2, justin.image.size.width, justin.image.size.height)];
    
    [self.view addSubview:justin];
	[justin release];
	
	kiss = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, background.image.size.width, background.image.size.height)];
	[self.view addSubview:kiss];
	[kiss setAlpha:0];
	[kiss release];
	
	
	//back button
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.exclusiveTouch = YES;
	[backButton setImage:[UIImage imageNamed:@"homebuttonKiss.png"] forState:UIControlStateNormal];
	[backButton addTarget: self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[backButton setFrame: CGRectMake(6*x2, 17*x2, 36*x2, 39*x2)];
	[self.view addSubview: backButton];
	
	timer = [NSTimer scheduledTimerWithTimeInterval: (0.8)
											 target: self
										   selector: @selector(action)
										   userInfo: nil
											repeats: YES];
	
    [super viewDidLoad];
}


- (void) action {
	if (gameEnd == NO) {
		numberItem = arc4random()%8+1;
		
		if (numberItem >= 4) numberItem = 4;
		
		NSString *fileName = [self imageName: [NSString stringWithFormat: @"kiss%d", numberItem]];
		UIImage *item = [UIImage imageNamed: fileName];
		[kiss setImage: item];
		
		CGPoint point = [KissGame locationItem];
		[kiss setFrame:CGRectMake(point.x, point.y, item.size.width, item.size.height)];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration: 0.2];
		[kiss setAlpha:1];
		[UIView commitAnimations];
		
		waitNext = NO;
		
		[self checkIn];	
	}
}


- (void) showResult: (NSString *)result {
	sound = [self createSound:result];
	[sound play];
	
	UIImage *image = [UIImage imageNamed:[self imageName: result]];
	UIImageView *message = [[UIImageView alloc] initWithImage: image];
	[message setFrame:CGRectMake((x2==2)?128:0, 0, message.image.size.width, message.image.size.height)];
	[message setAlpha:0];
	[self.view addSubview:message];
	[message release];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration: 0.5];
	[message setAlpha:1];
	[UIView commitAnimations];
}


- (void) checkIn {
	if (CGRectContainsRect(justin.frame, kiss.frame)) {
		if (numberItem >= 4) {
			justinTouch = NO;
			waitNext = YES;
			gameEnd = YES;
			sound = [self createSound:@"paperball"];
			[sound play];
			 
			[self performSelector:@selector(showResult:) withObject:@"lose" afterDelay:1];
		}
		else {
			[kissSound play];
			gotKisses++;
			waitNext = YES;
		}
	}
	
	if (gotKisses == 3) {
		gameEnd = YES;
		[self performSelector:@selector(showResult:) withObject:@"win" afterDelay:1];
	}
}


- (void) remove {
	[timer invalidate];
    [sound stop];
    [sound release];
    [ad stopAds];
    //[ad release];
    NSLog(@"KissGame retain count:%d",[self retainCount]);
    [self dismissModalViewControllerAnimated:YES];
}


- (void) back {
    [self remove];
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView:self.view];
//	CGPoint location = [touch locationInView:self.view];
	
	if(CGRectContainsPoint(justin.frame, location) && gameEnd == NO) {
		justinTouch = YES;
	}
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView:touch.view];
	
	if (justinTouch) {
		[justin setCenter:location];
		
		if (waitNext == NO) 
			[self checkIn];
	}
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	justinTouch = NO;
}


- (AVAudioPlayer *) createSound: (NSString *)soundName {
    [self.sound stop];
	self.sound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: soundName ofType:@"mp3"]] error:nil];
	self.sound.numberOfLoops = 0;
	return self.sound;
}


+ (CGPoint) locationItem {
	BOOL good = NO;
	CGPoint point;
	
	int x = (x2 == 2) ? 64 : 20;
	int y = (x2 == 2) ? 112 : 20;
	
	while (!good) {
		point = CGPointMake((arc4random()%280+x)*x2, (arc4random()%440+y)*x2);
		
		CGPoint tempPoint1 = CGPointMake(point.x+44*x2, point.y+40*x2);
		CGPoint tempPoint2 = CGPointMake(point.x-44*x2, point.y-40*x2);
		
		if (!CGRectContainsPoint(justin.frame, tempPoint1) && !CGRectContainsPoint(justin.frame, tempPoint2)) {
			good = YES;
			break;
		}
	}
	
	return point;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
