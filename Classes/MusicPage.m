//
//  MusicPage.m
//  Popstar
//
//  Created by Alexander Morgun on 8/30/11.
//  Copyright 2011 InjoiT.com. All rights reserved.
//

#import "MusicPage.h"

@implementation MusicPage

PopstarAppDelegate *app;
short int x2;


- (NSString *) imageName: (NSString *)name {
	NSString *imageName = (x2 == 2) ? [NSString stringWithFormat:@"%@@2x.png", name] : [NSString stringWithFormat:@"%@.png", name];
	return imageName;
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    // Initialization code.
		app = (PopstarAppDelegate*)[[UIApplication sharedApplication] delegate];
		x2 = (app.isPad) ? 2 : 1;
		
        UIImage *img = [UIImage imageNamed:[self imageName:@"background_music"]];
		UIImageView *background = [[UIImageView alloc] initWithImage:img];
        [background setFrame:CGRectMake(0, 0, background.image.size.width, background.image.size.height)];
        [self addSubview:background];
        [background release];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];    
		backButton.exclusiveTouch = YES;
        [backButton setImage: [UIImage imageNamed:[self imageName:@"backbutton"]] forState:UIControlStateNormal]; 
        [backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setFrame:CGRectMake(5*x2, 5*x2, backButton.imageView.image.size.width, backButton.imageView.image.size.height)];
        [self addSubview:backButton];
        
		if (x2 == 1) {
			UIButton *mediaPlayerButton = [UIButton buttonWithType:UIButtonTypeCustom];
			mediaPlayerButton.exclusiveTouch = YES;
			[mediaPlayerButton setImage: [UIImage imageNamed:[self imageName:@"choosemusicbutton"]] forState:UIControlStateNormal]; 
			[mediaPlayerButton addTarget:self action:@selector(openMediaPicker) forControlEvents:UIControlEventTouchUpInside];
			[mediaPlayerButton setFrame:CGRectMake(background.image.size.width/2-mediaPlayerButton.imageView.image.size.width/2, background.image.size.height-10*x2-mediaPlayerButton.imageView.image.size.height, mediaPlayerButton.imageView.image.size.width, mediaPlayerButton.imageView.image.size.height)];
			[self addSubview:mediaPlayerButton];
		}
        
        int iconCount = 0;
        
        for(int j = 0; j<3; j++){ 
            for(int i = 0; i<6; i++){
                UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
				b1.exclusiveTouch = YES;
				UIImage *img = [UIImage imageNamed:[self imageName:[NSString stringWithFormat:@"mb%d",++iconCount]]];
                [b1 setImage:img  forState:UIControlStateNormal]; 
                [b1 addTarget:self action:@selector(linkPress:) forControlEvents:UIControlEventTouchUpInside];
                [b1 setTag:iconCount];
                
                int xShift = 0;
                if(i>2) xShift = 13;
                
                [b1 setFrame:CGRectMake((8+i*50+xShift)*x2, (108+j*108)*x2, img.size.width, img.size.height)];
                [self addSubview:b1];
            }
        }   
    }
    return self;
}

- (void) remove {
	[self removeFromSuperview];
}


#pragma mark - Button actions

- (IBAction)backButton:(UIButton*)sender {  
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration: 0.4];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector:@selector(remove)];
	[self setAlpha:0];
	[UIView commitAnimations];
}


- (IBAction)linkPress:(UIButton*)sender {   
    //link action
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"musicLinks" ofType:@"plist"]] autorelease] valueForKey:[NSString stringWithFormat:@"%d",sender.tag]]]];
}


- (void) openMediaPicker {
    if (!controller) {
        controller = [[UIViewController alloc] init];
        controller.view = self;
    }
    
    [controller.view setBackgroundColor:[UIColor clearColor]];
    
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    [controller presentModalViewController:mediaPicker animated:YES];
    [mediaPicker release];
}
	

// Media picker delegate methods
- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
	// We need to dismiss the picker
	[controller dismissModalViewControllerAnimated:YES];
	
    MPMediaItem *item = [[mediaItemCollection items] objectAtIndex:0];
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];

	// Assign the selected item(s) to the music player and start playback.
	//[backgroundTrack stop];
	//self.backgroundTrack = nil;
	
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    app = (PopstarAppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.backgrSound pause];
	[app.userSounds release];
    [app setUserSounds:[[AVPlayer alloc] initWithURL:url]];
    [app.userSounds play];
	app.useriPod = YES;
    
    [playerItem release];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    // User did not select anything
    // We need to dismiss the picker
    [controller dismissModalViewControllerAnimated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
    [controller release];
}


@end
