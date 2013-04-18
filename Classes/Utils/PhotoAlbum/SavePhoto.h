//
//  SavePhoto.h
//  paperdolls
//
//  Created by Alexander Morgun, Andrew Kopanev on 4/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Helper.h"

@interface SavePhoto : UIView <UIAlertViewDelegate> {
	
@private
	UIView *tempView;
	UIImage *tempImg;
	
	BOOL cover;
}

- (void) windowOfLevel:(UIView *)levelView withCover:(BOOL)_cover;


@end