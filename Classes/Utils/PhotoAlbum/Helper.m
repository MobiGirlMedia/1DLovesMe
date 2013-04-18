//
//  Helper.m
//  My Fashion
//
//  Created by Andrew Kopanev on 3/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Helper.h"


@implementation Helper

+ (NSString*) getDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex: 0];	
}

+ (NSString*) getUserImagesFolder {
	return [Helper getDocumentsDirectory];
	return [NSString stringWithFormat: @"%@/%@", [Helper getDocumentsDirectory], @"userImages"];
}


@end
