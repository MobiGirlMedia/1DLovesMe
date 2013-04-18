//
//  Models.m
//  Popstar
//
//  Created by Alexander Morgun on 8/22/11.
//  Copyright 2011 InjoiT.com. All rights reserved.
//

#import "Models.h"
#import "ImageUtils.h"


@implementation Models

@synthesize viewController;

short int x2;

float coordinate[4][2] = {{44, 82}, {167, 34}, {60, 270}, {178, 211}};

float degrees [4] = { -8, 16, -12, 5};


- (NSString *) imageName: (NSString *)name {
	NSString *imageName = (x2 == 2) ? [NSString stringWithFormat:@"%@@2x.png", name] : [NSString stringWithFormat:@"%@.png", name];
	return imageName;
}


- (id)initWithFrame:(CGRect)frame controller:(UIViewController*) _vc{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.viewController=_vc;
        // Initialization code.
		self.backgroundColor = [UIColor purpleColor];
		app = (PopstarAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        int y=self.frame.size.height-MGSize_iPhone_Portrait.height;
        if (app.isPad) {
            y=self.frame.size.height-MGSize_iPad_Portrait.height;;
        }
		ad=[[MGAd alloc] initForBannerWithSecret:kAdSecret origin:CGPointMake(0, y) orientation:UIInterfaceOrientationPortrait];
        [ad showAdsOnViewController:self.viewController];
        
		x2 = (app.isPad) ? 2 : 1;
		
		
		NSString *backgrName = [self imageName: @"backgr_gilrs"];
		if (x2 == 2) {
			backgrName = @"backgr_gilrs_ipad.png";
		}
		
		UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgrName]];
		[background setFrame:self.viewController.view.frame];
        
		[self addSubview:background];
		[background release];
		
		//Place holder for iPhone screen
		platform = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		[self addSubview:platform];
		[platform release];
		
//		//Frame image
//		UIImageView *frame = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
//		[self addSubview:frame];		
//		
		if (x2 == 2) {
			[platform setFrame:CGRectMake(64, 32, 640, 960)];
//			[frame setImage:[UIImage imageNamed:@"home_frame.png"]];
		}
//		[frame release];

		
		//Show covers
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0*x2, 18*x2, 320*x2, 421*x2)];
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = YES;
		//scrollView.backgroundColor = [UIColor greenColor];
		scrollView.bounces = NO;
		//scrollView.pagingEnabled = YES;
		scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
		scrollView.delaysContentTouches = YES;//?!
		[platform addSubview:scrollView];
		
		[self updateCovers];
		
		scrollView.delegate = self;

		
		//back button
		UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		backButton.exclusiveTouch = YES;
		[backButton setImage:[UIImage imageNamed:[self imageName: @"backbutton"]] forState:UIControlStateNormal];
		[backButton addTarget: self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
		[backButton setFrame: CGRectMake(62*x2, 60*x2, 36*x2, 39*x2)];
		[platform addSubview: backButton];
		
    }
    return self;
}

- (void) update {
	if (app.bigCover) {
		NSLog(@"photoAlbum");
		[photoAlbum release];
		photoAlbum = nil;
		[self updateCovers];
		[timer invalidate];
		[app bigCover:NO];
	}
}

- (void) updateCovers {
	for (UIButton *b in [scrollView subviews]) {
		[b removeFromSuperview];
	}
	
	int heightOfColumn = -420;
	short int i = 0, t = 0, j = 0;
	
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	documentsDirectory = [NSString stringWithFormat:@"%@/covers", documentsDirectory];
	NSMutableArray *covers = [[NSMutableArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error: nil]];


	if (covers.count != 0)
		for (int c = covers.count; c>0; c--) {
			NSString *s = [covers objectAtIndex: c-1];
			UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, s]];
	//		image = [ImageUtils imageWithImage:image scaledToSize:CGSizeMake(100, 131)];

			UIButton *buttonItm = [UIButton buttonWithType:UIButtonTypeCustom];
			buttonItm.exclusiveTouch = YES;

			buttonItm.adjustsImageWhenHighlighted = NO;
			
			[buttonItm setContentMode:UIViewContentModeCenter];
	//		[buttonItm addTarget:self action:@selector(showBigCover:) forControlEvents:UIControlEventTouchUpInside];
			[buttonItm setImage:image forState:UIControlStateNormal];
			
			if (i == 0)
				heightOfColumn += 420;
			
			[buttonItm setFrame:CGRectMake(coordinate[i][0]*x2, heightOfColumn*x2 + coordinate[i][1]*x2, 100*x2, 131*x2)];		
			buttonItm.transform = CGAffineTransformMakeRotation(degrees[i]*M_PI/180);
			
			[buttonItm setTag:t];
			[scrollView addSubview:buttonItm];
			
			
			t++;
			i++;
			
			if (i == 4) {
				i = 0;
			}
			
			j = (i%4) ? j : j+1;
		}
	
	[covers release];
	
	scrollView.contentSize = CGSizeMake(61, (heightOfColumn+420)*x2);
}


- (void) remove {
    [ad stopAds];
    //[ad release];
    [self.viewController dismissModalViewControllerAnimated:YES];
}

- (void) back {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration: 0.4];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector:@selector(remove)];
	[self setAlpha:0];
	[UIView commitAnimations];
}


- (void) showBigCover: (UIButton *)sender {
	if (!photoAlbum) 
		photoAlbum = [[PhotoAlbum alloc] initWithFrame:CGRectMake(0, 0, 320*x2, 480*x2)];
	photoAlbum.alpha = 0;
	[platform addSubview:photoAlbum];
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8];
	[photoAlbum setAlpha:1];
	[UIView commitAnimations];
	
	[photoAlbum showView:sender.tag];
	
	timer = [NSTimer scheduledTimerWithTimeInterval: (0.7)
									 target: self
								   selector: @selector(update)
								   userInfo: nil
									repeats: YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView {
	double _shelf = (_scrollView.contentOffset.y-33) / 420;
	int shelf = round(_shelf);
	NSLog(@"int: %d", shelf);
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	[_scrollView setContentOffset:CGPointMake(0, 420*shelf)];
	[UIView commitAnimations];
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)_scrollView willDecelerate:(BOOL)decelerate {
	double _shelf = (_scrollView.contentOffset.y-33) / 420;
	int shelf = round(_shelf);
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	[_scrollView setContentOffset:CGPointMake(0, 420*shelf)];
	[UIView commitAnimations];
}


- (void)dealloc {
    [super dealloc];
	
	[photoAlbum release];
	
	[scrollView release];
}


@end
