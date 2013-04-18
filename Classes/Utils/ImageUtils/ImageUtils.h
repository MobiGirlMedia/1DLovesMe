//
//  ImageUtils.h
//  Created by Andrew Kopanev on 8/30/10.
//

#import <Foundation/Foundation.h>

typedef enum {
	JIMSame = 0,
	JIMHorizontal,
	JIMVertical
} JoinImageMode;

@interface ImageUtils : NSObject {

}

+ (ImageUtils*) getInstance;

+ (CGFloat) max: (CGFloat) v1 or: (CGFloat) v2;
+ (NSString *) imagesDirectory;
//+ (NSArray *) fileForFolder: (NSString *) filesFolder animation: (BOOL) forAnimation;
+ (UIImage *) putImage: (UIImage *) img1 onImage: (UIImage *) img2 usingMode: (JoinImageMode) mode;
+ (UIImage *) croppedImage:(UIImage *)imageToCrop withRect:(CGRect)rect;
+ (UIImage *) image: (UIImage*) img zoomedToWidth: (float) width croppedByHeight: (float) height;
+ (UIImage *) imageWithImage:(UIImage *)image thatFitsInSize: (CGSize) size;
+ (UIImage *) imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage *) partOfImage: (UIImage*) img croppedToSize: (CGSize) size;
+ (UIImage *) imageFromView: (UIView *) view;

+ (UIImageView*) animationImage: (UIImageView *)image animSpeed:(float)animDuration repeatCount: (int)repeat array: (NSArray*)animArray;
	//+ (UIImageView*) tempZ: (float)animDuration repeatCount: (int)repeat array: (NSArray*)animArray location:(CGRect)location;

@end