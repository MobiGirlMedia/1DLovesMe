//
//  PhotoAlbum.m
//  paperdolls
//
//  Created by Alexander Morgun, on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PhotoAlbum.h"
#import "Helper.h"


@implementation PhotoAlbum

@synthesize imageFilePaths, photoView;

int x2;


- (NSString *) imageName: (NSString *)name {
	NSString *imageName = (x2 == 2) ? [NSString stringWithFormat:@"%@@2x.png", name] : [NSString stringWithFormat:@"%@.png", name];
	return imageName;
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {		
		//[FlurryAPI logEvent:@"User looks album"];
		
		PopstarAppDelegate *app = (PopstarAppDelegate*)[[UIApplication sharedApplication] delegate];
		x2 = (app.isPad) ? 2 : 1;
		
		UIImage *backgr = [UIImage imageNamed:[self imageName: @"FavPicsBG"]];
		UIImageView *background = [[UIImageView alloc] initWithImage:backgr];
		[self addSubview: background];
		[background release];		
		
		photoView = [[UIImageView alloc] initWithFrame: CGRectMake(28, 75, 265*x2, 347*x2)];
		photoView.backgroundColor = [UIColor whiteColor];
		[self addSubview: photoView];
		[photoView release];
		
		self.backgroundColor = [UIColor whiteColor];
		
		NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: [NSString stringWithFormat:@"%@/covers/", [Helper getUserImagesFolder]] error: nil];
		imageFilePaths = [[NSMutableArray alloc] initWithArray:files];
		
		//Different objects for album view
		
		UIImage *homeImage = [UIImage imageNamed:[self imageName: @"backbutton"]];
		UIButton *home = [UIButton buttonWithType: UIButtonTypeCustom];
		[home setImage: homeImage forState: UIControlStateNormal];
		[home setFrame: CGRectMake(10*x2, 436*x2, homeImage.size.width, homeImage.size.height)];
		[home addTarget: self action: @selector(hideAlbum) forControlEvents: UIControlEventTouchUpInside];
		[self addSubview: home];
		
		UIImage *magImage = [UIImage imageNamed:[self imageName: @"resetbutton"]];
		UIButton *remove = [UIButton buttonWithType: UIButtonTypeCustom];
		[remove addTarget: self action: @selector(removeCurrentImage) forControlEvents: UIControlEventTouchUpInside];
		[remove setImage: magImage forState: UIControlStateNormal];
		[remove setFrame: CGRectMake(282*x2, 436*x2, magImage.size.width, magImage.size.height)];
		[self addSubview: remove];
	}
	return self;
}

- (void) hideAlbum {
	PopstarAppDelegate *app = (PopstarAppDelegate*)[[UIApplication sharedApplication] delegate];
	[app bigCover:YES];
	
	[self removeFromSuperview];
}

- (void) remove {
	[self.superview removeFromSuperview];    //album is a subview of model object, when go to main model has to be released
	[self release];
}

- (void)alertView:(UIAlertView *)dialogSave clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		@synchronized(self) {
			NSString *directory = [NSString stringWithFormat: @"%@/covers", [Helper getUserImagesFolder]];
			NSString *filePath = [NSString stringWithFormat: @"%@/%@", directory, [imageFilePaths objectAtIndex: currentImageIndex]];
			BOOL deleted = [[NSFileManager defaultManager] removeItemAtPath: filePath error: nil];
			if (!deleted) {
				NSLog(@"error while deleting!");
			}
			
			NSArray *currentFilePaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error: nil];
			[imageFilePaths setArray: currentFilePaths];
			
			if (imageFilePaths.count) {
				if (currentImageIndex >= imageFilePaths.count) 
					currentImageIndex = imageFilePaths.count - 1;
				
				NSString *fPath = [NSString stringWithFormat: @"%@/%@", directory, [imageFilePaths objectAtIndex: currentImageIndex]];
				photoView.image = [UIImage imageWithContentsOfFile: fPath];
			}
			
			else 
				photoView.image = nil;
		}
	}
}


- (void) removeCurrentImage {
	if (!imageFilePaths.count) return;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil
													message: @"Wait! Do you want to delete this photo?" 
												   delegate: self
										  cancelButtonTitle: @"NO"
										  otherButtonTitles: @"YES", nil];
	
	[alert show];
	[alert release];
}


- (void) showView: (int) numberOfImage {	
	if ([imageFilePaths count]) {
		currentImageIndex = numberOfImage;
		
		NSString *imgFilePath = [NSString stringWithFormat: @"%@/covers/%@", [Helper getUserImagesFolder], [imageFilePaths objectAtIndex: currentImageIndex]];
		
		UIImage *img = [UIImage imageWithContentsOfFile: imgFilePath];
		
		photoView.image = img;
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Whoops!"
														message: @"You have not added any pictures to your look book!" 
													   delegate: nil 
											  cancelButtonTitle: @"OK" 
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {	
	for (UITouch *touch in touches) {
		if(CGRectContainsPoint(photoView.frame, [touch locationInView:self])) {
			if (!imageFilePaths.count) return;
			@synchronized (self) {
				if (++currentImageIndex >= imageFilePaths.count) {
					currentImageIndex = 0;
				}
				
				NSString *imgFilePath = [NSString stringWithFormat: @"%@/covers/%@", [Helper getUserImagesFolder], [imageFilePaths objectAtIndex: currentImageIndex]];
				UIImage *img = [UIImage imageWithContentsOfFile: imgFilePath];
				
				photoView.image = img;
				
				PopstarAppDelegate *dApp = (PopstarAppDelegate *) [[UIApplication sharedApplication] delegate];
				[UIView beginAnimations: nil context:NULL];
				[UIView setAnimationDuration: 0.8];
				[UIView setAnimationTransition: UIViewAnimationTransitionCurlDown
									   forView: dApp.window
										 cache: NO];
				
				[prevView removeFromSuperview];
				[self insertSubview: photoView belowSubview: prevView];
				
				[UIView commitAnimations];
				prevView.image = img;
			}
		}
	}
}


- (void)dealloc {
	[imageFilePaths release];
	[super dealloc];
}


@end