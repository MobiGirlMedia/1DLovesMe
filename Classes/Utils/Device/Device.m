//
//  Device.m
//  TheRoyals
//
//  Created by Alexander Morgun on 3/8/11.
//

#import "Device.h"


@implementation Device


@synthesize mainFolder;
@synthesize frame;
@synthesize scale, pad;


+ (Device*) getInstance {
	static Device *sharedSingleton = nil;
	
	@synchronized(self) {
		if (!sharedSingleton) {
			sharedSingleton = [[Device alloc] init];
		}
	}
	return sharedSingleton;
}


- (id) init {
	if (self = [super init]) {
		mainFolder = [NSString new];
		
		if ([Device runningUnderiPad]) {		
			frame = CGRectMake(0, 0, 1024, 768);
			mainFolder = @"ipad";
			
		} else {
			frame = CGRectMake(0, 0, 480, 320);
			mainFolder = @"iphone";
		}
	}
		//[Device actualOS] ? scale = 1.6 : scale = 1.0;
	
	return self;
}

+ (BOOL) actualOS {
	float currentVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	return (currentVersion>=4.0) ? YES : NO;
}

+ (BOOL) runningUnderiPad {
	NSString *modelName = [[UIDevice currentDevice] model];
	return [modelName rangeOfString: @"iPad"].location != NSNotFound;
}


+ (BOOL) multitaskingSupported { //поддерживает ли устройство многозадачность?
	BOOL multitask = NO;
	if ([Device actualOS]) multitask = [[UIDevice currentDevice] isMultitaskingSupported];
	return multitask;
}

- (NSString *) localizedModel { //возвращает локализацию девайса
	return [[UIDevice currentDevice] localizedModel];
}


- (NSString *) systemName { //iPhone OS, AppleTV OS..
	return [[UIDevice currentDevice] systemName];
}


- (NSString *) systemVersion { //iOS version: 4.1, 4.2 ...
	return [[UIDevice currentDevice] systemVersion];
}


- (NSString *) deviceModel { //Possible examples of model strings are @”iPhone” and @”iPod touch”.
	return [[UIDevice currentDevice] model];
}


- (NSString *) UUID { //Unique Device Identifier
	return [[UIDevice currentDevice] uniqueIdentifier];
}


+ (BOOL) screenIs2xResolution { //возврщает тру, если ретина дисплей
	return 2.0 == [Device mainScreenScale];
}

+ (CGFloat) mainScreenScale { // if retina display return 2.0 scale, another 1.0
	CGFloat scale = 1.0;
	UIScreen* screen = [UIScreen mainScreen];
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		scale = [screen scale];
	}
	return scale;
}

@end