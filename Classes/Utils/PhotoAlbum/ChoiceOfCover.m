//
//  ChoiceOfCover.m
//  Popstar
//
//  Created by Alexander Morgun on 10/23/11.
//  Copyright (c) 2011 InjoiT.com. All rights reserved.
//

#import "ChoiceOfCover.h"

@implementation ChoiceOfCover
//@synthesize ivFaceImageData;

PopstarAppDelegate *app;

short int x2;

UIButton *changeBackground;
UIButton *saveButton;

- (NSString *) imageName: (NSString *)name {
	NSString *imageName = (x2 == 2) ? [NSString stringWithFormat:@"%@@2x.png", name] : [NSString stringWithFormat:@"%@.png", name];
	return imageName;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
        /////////////////////////////
		app = (PopstarAppDelegate*)[[UIApplication sharedApplication] delegate];
		
		x2 = (app.isPad) ? 2 : 1;

		NSString *backgrName = [self imageName: @"FavPicsBG"];
		
		if (x2 == 2) {
			backgrName = @"PictureBGipad.png";
		}
		
		//Interface
		UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.frame];
		[backImageView setImage:[UIImage imageNamed:backgrName]];
		[self addSubview: backImageView];
		[backImageView release];

		
		//Place holder for iPhone screen
		UIView *platform = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		[self addSubview:platform];
		[platform release];

		
 /*       UIImageView *ivFaceImage = [[UIImageView alloc]initWithFrame:CGRectMake(26*x2, 72*x2, 276*x2, 350*x2)];
        //[ivFaceImage setImage:[UIImage imageWithData:ivFaceImageData]];
        [ivFaceImage setImage:app.myPhoto];
        [platform addSubview:ivFaceImage];
        NSLog(@"qwe=%@",app.myPhoto);
*/
		if (x2 == 2) {
//			[self setFrame:CGRectMake(0, 0, 768, 1024)];
			[platform setFrame:CGRectMake(64, 32, 640, 960)];
		}

		//back button
		UIImage * bImg = [UIImage imageNamed: @"homebuttonKiss.png"];
		UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[backButton setImage:bImg forState:UIControlStateNormal];
		[backButton addTarget: self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
		[backButton setFrame: CGRectMake(6*x2, 435*x2, bImg.size.width, bImg.size.height)];
		[platform addSubview: backButton];
        
		//General part		
		bottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320*x2, 480*x2)];
		[platform addSubview: bottom];
        [bottom setHidden:YES];
		[bottom setImage:nil];
		[bottom release];
		
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: [Helper getUserImagesFolder] error: nil];
		NSString *imgFilePath = [NSString stringWithFormat: @"%@/%@", [Helper getUserImagesFolder], [files objectAtIndex:([files count]-3)]];
		UIImage *img = [UIImage imageWithContentsOfFile: imgFilePath];
		UIImageView *savedGirl = [[UIImageView alloc] initWithFrame:CGRectMake(-30*x2, -15*x2, 380*x2, 530*x2)];
		[savedGirl setImage:img];
		[platform addSubview: savedGirl];
        
		savedGirl.transform = CGAffineTransformMakeScale(0.68, 0.68);
		//[savedGirl setCenter:CGPointMake(180*x2, 259*x2)];
		[savedGirl setBackgroundColor:[UIColor clearColor]];
		[savedGirl release];
        
		changeBackground = [UIButton buttonWithType: UIButtonTypeCustom];
		changeBackground.frame = CGRectMake(26*x2, 72*x2, 276*x2, 350*x2);
		[changeBackground addTarget: self action:@selector(showMagazine:) forControlEvents:UIControlEventTouchUpInside];
		[platform addSubview: changeBackground];
		
		[self showMagazine:changeBackground];
        
		top = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320*x2, 480*x2)];
		[platform addSubview: top];
        [top setHidden:YES];
		[top setImage: nil];
		[top release];
		
		
		UIImage * plusImg = [UIImage imageNamed: [self imageName: @"savebutton"]];
		saveButton = [UIButton buttonWithType: UIButtonTypeCustom];
		saveButton.frame = CGRectMake(238*x2, 394*x2, plusImg.size.width, plusImg.size.height);
		[saveButton setImage: plusImg forState: UIControlStateNormal];
		[saveButton addTarget: self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
		[platform addSubview: saveButton];
		
    }
    return self;
}

- (void) saveImage {
	[app.cameraSound play];
	
	[saveButton setHidden:YES];
    SavePhoto *savePhoto = [SavePhoto alloc];
	[savePhoto windowOfLevel:self withCover:YES];
	[savePhoto release];
	
	[self performSelector:@selector(back) withObject:nil afterDelay: 0.2];
}

- (void) showMagazine:(UIButton*) sender {
	changeBackground.tag++;
	
	UIImage *imageBottom = [UIImage imageNamed:[self imageName: [NSString stringWithFormat:@"BG%d", changeBackground.tag]]];
	UIImage *imageTop = [UIImage imageNamed:[self imageName: [NSString stringWithFormat:@"BG%dsaying", changeBackground.tag]]];
	
	[bottom setImage:imageBottom];
	[top setImage:imageTop];
	
	if (changeBackground.tag == 8) 
		changeBackground.tag = 0;
}


- (void) back {
	[self removeFromSuperview];
}

@end
