//
//  Device.h
//  TheRoyals
//
//  Created by Alexander Morgun on 3/8/11.
//

#import <Foundation/Foundation.h>


@interface Device : NSObject {
	@public
	NSString *mainFolder;
	CGRect frame;
	float scale;
}

@property (retain) NSString *mainFolder;
@property CGRect frame;
@property float scale;
@property float pad;


+ (Device*) getInstance;

+ (BOOL) runningUnderiPad;
+ (BOOL) multitaskingSupported;
+ (BOOL) actualOS;
+ (BOOL) screenIs2xResolution;

- (NSString *) localizedModel;
- (NSString *) systemName;
- (NSString *) systemVersion;
- (NSString *) deviceModel;
- (NSString *) UUID;

+(CGFloat) mainScreenScale;

@end