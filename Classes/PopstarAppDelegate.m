//
//  PopstarAppDelegate.m
//  Popstar
//
//  Created by Alexander Morgun on 8/22/11.
//  Copyright 2011 InjoiT.com. All rights reserved.
//

#import "PopstarAppDelegate.h"

#import "Reachability.h"

@implementation PopstarAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize backgrSound, userSounds;

@synthesize bigCover;
@synthesize useriPod;

@synthesize cameraSound;

@synthesize myPhoto;

AVAudioPlayer *splashSound;
LoadingView *loadingView;

BOOL didPaused = NO;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    // Override point for customization after application launch.

	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

#ifdef SELENA
    [FlurryAnalytics startSession:@"7FM4572KRNECEQ26YUEG"];
#elif BEYONCE
	[FlurryAnalytics startSession:@"TKIBNCM6CJ9Z6YS2T3SD"];
#else
	[FlurryAnalytics startSession:@"MZ1LBQPCXH1V8WY6DZZT"];
#endif
    
	[FlurryAnalytics logEvent:[NSString stringWithFormat:@"Launched on %@", (self.isPad) ? @"iPad" : @"iPhone"]];
	
		//Инициализация заставки и фонового звука
	splashSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Appsnminded" ofType:@"wav"]] error:nil];
	[splashSound setVolume:0.4];
	[splashSound play];

	backgrSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"background" ofType:@"mp3"]] error:nil];
	
    backgrSound.numberOfLoops = -1;
	[backgrSound setVolume:0.1];

	userSounds = [[AVPlayer alloc] init];
	
    loadingView = [[LoadingView alloc] initWithNibName:@"LoadingView" bundle:nil];
	if (self.isPad) {
		[loadingView.view setFrame:CGRectMake(0, 0, 768, 1024)];
		[loadingView.background setImage:[UIImage imageNamed:@"Default-Portrait~ipad.png"]];
	}
	
	[window	addSubview:loadingView.view];
    [window makeKeyAndVisible];
	
	[self performSelector:@selector(loading) withObject:nil afterDelay:3.0f];
	
	
	fileManager = [NSFileManager defaultManager];
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *theFileName = @"items.plist"; //Change this appropriately
	NSString *oldPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], theFileName];
	newPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, theFileName];
	
	NSLog(@"new path: %@", newPath);

//	NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
	
	cameraSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource: @"camera" ofType:@"mp3"]] error:nil];
	cameraSound.numberOfLoops = 0;
	

	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"noFirstAppLoad"] == NO) {
		NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"covers"];
		if (![fileManager fileExistsAtPath:dataPath])
			[fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
		
		[[NSFileManager defaultManager] copyItemAtPath:oldPath toPath:newPath error:nil];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"noFirstAppLoad"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
/*	else {
		//Check for update
		if (![currentVersion isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"currentVersion"]]) {
			
			oldList = [[NSMutableDictionary alloc] initWithDictionary: [NSDictionary dictionaryWithContentsOfFile:newPath]]; //? mutable
			newList = [[NSMutableDictionary alloc] initWithDictionary: [NSDictionary dictionaryWithContentsOfFile:oldPath]]; //? mutable
			
			[self comparePlist];
			
			[[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"currentVersion"];			
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}*/

    return YES;
}


- (BOOL) isPad {
#ifdef UI_USER_INTERFACE_IDIOM
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
    return NO;
#endif
}


- (void)loading {
	[loadingView.view removeFromSuperview];	
	[loadingView release];
	
	[splashSound stop];
	[splashSound release];
	
	//Инициализация и отображение главного окна
	[window addSubview:viewController.view];
	//[viewController.view addSubview:viewController.startScreen];
	if (self.isPad) {
		[viewController.start_frame setFrame:CGRectMake(0, 0, 768, 1024)];
		[viewController.start_frame setImage:[UIImage imageNamed:@"home_frame.png"]];
		[viewController.startScreen setFrame:CGRectMake(64, 32, 640, 960)];
		[viewController.mainView setFrame:CGRectMake(64, 32, 640, 960)];
		[viewController.start_bgd setFrame:CGRectMake(0, 0, 640, 960)];
		[viewController.start_bgd setImage:[UIImage imageNamed:@"backgr_start@2x.png"]];
	}
	
	[viewController.startScreen setHidden:YES];
	[viewController styleNow];
	
	[backgrSound play];

}


- (void) bigCover: (BOOL) state {
	bigCover = state;
}


- (void) startPlay {	
	[self reviewCounter];
	
	[viewController.view setAlpha:0];
	self.window.rootViewController = viewController;
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
	[viewController.view setAlpha:1];
	[UIView commitAnimations];
}

/*
- (void) comparePlist {
	//NSMutableDictionary *globalDictionary = [[NSMutableDictionary alloc] init];
	
	static NSString *wardrobe[6] = { @"taylor", @"miley", @"selena", @"beyonce", @"nicki", @"katy" };
	static NSString *category[3] = { @"redcarpet", @"onstage", @"outnabout" };
	
	for (int i=0; i<6; i++) {
		NSMutableDictionary *oldCategory = [[NSMutableDictionary alloc] initWithDictionary:[oldList objectForKey:wardrobe[i]]]; //шесть категорий
		NSMutableDictionary *newCategory = [[NSMutableDictionary alloc] initWithDictionary:[newList objectForKey:wardrobe[i]]]; //шесть категорий
		
		for (int j=0; j<3; j++) {
			NSArray *oldItemsList = [[NSArray alloc] initWithArray:[oldCategory objectForKey:category[j]]]; //массив с списком итемов
			NSArray *newItemsList = [[NSArray alloc] initWithArray:[newCategory objectForKey:category[j]]]; //массив с списком итемов
			
			if ([oldItemsList count] < [newItemsList count]) {
				NSMutableArray *tempList = [[NSMutableArray alloc] init];
				
				short int fix = 0;
				
				for (int t=0; t<[newItemsList count]; t++) {
					short int shift = t-fix;
					NSString *oldItem = (shift < [oldItemsList count]) ? [[oldItemsList objectAtIndex:shift] objectAtIndex:0] : @"";
					NSString *newItem = [[newItemsList objectAtIndex:t] objectAtIndex:0];
					if (![oldItem isEqualToString:newItem] || shift > [oldItemsList count]) {
						[tempList addObject:[newItemsList objectAtIndex:t]];
						fix++;
					}
					else {
						[tempList addObject:[oldItemsList objectAtIndex:shift]];
					}
				}
				
				[oldCategory setObject:tempList forKey:category[j]];
				[tempList release];
			}
			
//			NSLog(@"старый файл: категория - %@, итемов: %d", category[j], [oldItemsList count]);
//			NSLog(@"новый файл: категория - %@, итемов: %d", category[j], [newItemsList count]);
			
			[oldItemsList release];
			[newItemsList release];
		}
		
		[oldList setObject:oldCategory forKey:wardrobe[i]];
		
		[oldCategory release];
		[newCategory release];
	}
	
	if ([oldList writeToFile:newPath atomically:YES]) {
		[FlurryAnalytics logEvent:[NSString stringWithFormat:@"User got update: %@, sucesful", [[NSUserDefaults standardUserDefaults] stringForKey:@"currentVersion"]]];
		NSLog(@"items.plist успешно перезаписан");
	}
	else {
		NSLog(@"items.plist не перезаписан");
		[FlurryAnalytics logEvent:[NSString stringWithFormat:@"User got update: %@, sucesful", [[NSUserDefaults standardUserDefaults] stringForKey:@"currentVersion"]]];
	}
	
	[oldList release];
	[newList release];
}
*/

#pragma mark Review request

- (void) reviewCounter {
	CGFloat reviewInt = [[NSUserDefaults standardUserDefaults] integerForKey: @"intValueKey"];
	
	if (reviewInt) {
		reviewInt++;
		[[NSUserDefaults standardUserDefaults] setInteger:reviewInt forKey:@"intValueKey"];
	}
	else {
		NSUserDefaults *reviewPrefs = [NSUserDefaults standardUserDefaults];
		[reviewPrefs setInteger:1 forKey: @"intValueKey"];
		[reviewPrefs synchronize]; // writes modifications to disk
	}
	
	
	if (reviewInt == 3)	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Love Justin Loves Selena?" 
														message:@"Then let us know. Please leave a review on iTunes. Thanks!"
													   delegate:self cancelButtonTitle:nil otherButtonTitles: @"OK, I'll Review It Now", @"Remind Me Later", @"Don't Remind Me", nil];
		[alert show];
		[alert release];
		
		reviewInt++;
		
		[[NSUserDefaults standardUserDefaults] setInteger:reviewInt forKey:@"intValueKey"];
	}
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		[FlurryAnalytics logEvent:@"User want to leave a review"];
		
		NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
		str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
		str = [NSString stringWithFormat:@"%@type=Purple+Software&amp;id=", str];
		
		// Here is the app id from itunesconnect
#ifdef SELENA
		str = [NSString stringWithFormat:@"%@497790117", str];
#elif BEYONCE
		str = [NSString stringWithFormat:@"%@497897925", str];
#else
		str = [NSString stringWithFormat:@"%@478156865", str];
#endif
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
		
	}
	else if (buttonIndex == 1) {
		[FlurryAnalytics logEvent:@"User want to leave a review later"];
		int startAgain = 0;
		[[NSUserDefaults standardUserDefaults] setInteger:startAgain forKey:@"intValueKey"];
	}
	else if (buttonIndex == 2) {
		[FlurryAnalytics logEvent:@"User don't want to leave a review"];
		int neverRemind = 4;
		[[NSUserDefaults standardUserDefaults] setInteger:neverRemind forKey:@"intValueKey"];
	}
}


#pragma mark -
#pragma mark MBProgressHUD methods

- (void)showHUD {
	if(!HUD){
		HUD = [[MBProgressHUD alloc] initWithView:self.window];
	}
	if (!HUDOnScreen) {
		[self.window addSubview:HUD];
		HUD.labelText = @"Loading...";
		[HUD show:YES];
		HUDOnScreen = YES;
	}
}

- (void)hideHUD {
	HUDOnScreen = NO;
	[HUD hide:YES];
}


- (BOOL)internetConnected {
	Reachability* reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {
        return NO;
    }    
    else if (remoteHostStatus == ReachableViaWWAN || (remoteHostStatus == ReachableViaWiFi)) {
		//EDGE or 3G connection found
		//wifi connection found
        return YES;
	}
    else
        return YES;
}



#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[cameraSound release];
	[backgrSound release];
    [viewController release];
    [window release];
    [super dealloc];
}


@end
