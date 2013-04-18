//
//  ChoiceOfCover.h
//  Popstar
//
//  Created by Alexander Morgun on 10/23/11.
//  Copyright (c) 2011 InjoiT.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Helper.h"
#import "SavePhoto.h"


@interface ChoiceOfCover : UIView {
	AVAudioPlayer *cameraSound;
	
	UIImageView *top;
    UIImageView *bottom;
}
//@property (nonatomic, retain) NSData *ivFaceImageData;
- (void) saveImage;

- (void) showMagazine:(UIButton*)sender;

- (void) back;

@end