//
//  ImageUtils.m
//  Created by Andrew Kopanev on 8/30/10.
//

#import "ImageUtils.h"
#import <QuartzCore/QuartzCore.h>


@implementation ImageUtils


+ (ImageUtils*) getInstance {
	static ImageUtils *sharedSingleton = nil;
	
	@synchronized(self) {
		if (!sharedSingleton) {
			sharedSingleton = [[ImageUtils alloc] init];
		}
	}
	return sharedSingleton;
}


//	//получение UIImage без кеширования изображений
//+ (UIImage*) loadImage:(NSString*)name inFolder:(NSString*)folder {
//	NSString *retina = ([Device screenIs2xResolution]) ? @"HQ" : @"";
//	NSString *path = [NSString stringWithFormat:@"%@/%@%@/%@/%@",[[NSBundle mainBundle] bundlePath], [[Device getInstance] mainFolder], retina, folder, name];
//	UIImage *img = [UIImage imageWithContentsOfFile:path];
//	if (!img) NSLog(@"File not loaded ! %@", path); //Закомментировать перед выпуском
//	return img;
//}

	//Вычисление пути к необходимой папке
+ (NSString *) imagesDirectory {
	static NSString* dPath = nil;
	if (!dPath) {
		dPath = [NSString stringWithFormat: @"%@", [[NSBundle mainBundle] bundlePath]];
		[dPath retain];
	}
	return dPath;
}
	//Парсинг изображений указанной папки, для стандартной анимации
//+ (NSArray *) fileForFolder: (NSString *) filesFolder animation: (BOOL) forAnimation {
//	NSMutableArray * rArray = [[NSMutableArray alloc] init];
//	NSString *retina = ([Device screenIs2xResolution]) ? @"HQ" : @"";
//	NSString *fPath = [NSString stringWithFormat:@"%@/%@%@/%@",[[NSBundle mainBundle] bundlePath], [[Device getInstance] mainFolder], retina, filesFolder];
//	NSArray * content = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: fPath
//																			error: nil];
//	if (forAnimation)
//		for (NSString * s in content) 
//			[rArray addObject: [ImageUtils loadImage: s inFolder:filesFolder]];
//	else for (NSString * s in content)
//		[rArray addObject: s];
//	
//	NSArray *returnArray = [NSArray arrayWithArray:rArray];
//	[rArray release];
//	
//	return returnArray;
//}


+ (UIImageView*) animationImage: (UIImageView *)image animSpeed:(float)animDuration repeatCount: (int)repeat array: (NSArray*)animArray {
	image.animationImages = animArray;
	image.animationDuration = animDuration; // seconds
	image.animationRepeatCount = repeat; // 0 =  forever
	image.contentMode = UIViewContentModeCenter;
	
	return image;
}


+ (CGFloat) max: (CGFloat) v1 or: (CGFloat) v2 {
	return v1 > v2 ? v1 : v2;
}

+ (UIImage *) putImage: (UIImage *) img1
			   onImage: (UIImage *) img2
			 usingMode: (JoinImageMode) mode {
	
	CGFloat nh = [ImageUtils max: img1.size.height or: img2.size.height];
	CGFloat nw = [ImageUtils max: img1.size.width or: img2.size.width];
	CGRect putR, onR;
	size_t w, h;
	
	if (mode == JIMVertical) {
		w = nw;
		h = img1.size.height + img2.size.height;
		
		onR = CGRectMake(w * .5 - img2.size.width * .5, 
						 0, 
						 img2.size.width, img2.size.height);
		putR = CGRectMake(w * .5 - img1.size.width,
						  img2.size.height,
						  img1.size.width, img1.size.height);
	} else if (mode == JIMHorizontal) {
		w = img1.size.width + img2.size.width;
		h = nh;
		onR = CGRectMake(0, h * .5 - img2.size.height * .5,
						 img2.size.width, img2.size.height);
		
		putR = CGRectMake(img2.size.width, h * .5 - img1.size.height * .5,
						  img1.size.width, img1.size.height);
	} else { // default - same mode
		w = nw;
		h = nh;
		
		onR = CGRectMake(w * .5 - img2.size.width * .5,
						 h * .5 - img2.size.height * .5,
						 img2.size.width, img2.size.height);
		putR = CGRectMake(w * .5 - img1.size.width * .5,
						  h * .5 - img1.size.height * .5,
						  img1.size.width, img1.size.height);
	}
	
	
	CGImageRef onImg = img2.CGImage;
	CGImageRef putImage = img1.CGImage;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef cgctx = CGBitmapContextCreate(NULL, 
											   w, h,
											   8, 0, 
											   colorSpace, kCGImageAlphaPremultipliedLast); 
	if (cgctx == NULL) {
        CGColorSpaceRelease( colorSpace );
		printf("cgtx error \n");
		return nil;
	}
	
	CGContextDrawImage(cgctx, onR, onImg);
	CGContextDrawImage(cgctx, putR, putImage);
	CGImageRef imageRef = CGBitmapContextCreateImage (cgctx);
	UIImage * newImage = [UIImage imageWithCGImage: imageRef];
	CGImageRelease(imageRef);
	CGContextRelease(cgctx);
	CGColorSpaceRelease( colorSpace );
	return newImage;
}

+ (UIImage *) croppedImage:(UIImage *)imageToCrop withRect:(CGRect)rect {
	CGImageRef cropped = CGImageCreateWithImageInRect(imageToCrop.CGImage, rect);
	UIImage *retImage = [UIImage imageWithCGImage: cropped];
	CGImageRelease(cropped);
	return retImage;
}
+ (UIImage *) image: (UIImage*) img zoomedToWidth: (float) width croppedByHeight: (float) height {
	float newImageHeight = width * img.size.height / img.size.width;
	UIImage *timg = [ImageUtils imageWithImage: img scaledToSize: CGSizeMake(width, newImageHeight)];
	UIImage *rImg = [ImageUtils croppedImage: timg withRect: CGRectMake(0, 0, width, height)];
	return rImg;
}

+ (UIImage *) imageWithImage:(UIImage *)image thatFitsInSize: (CGSize) size {
	float wRatio = size.width / image.size.width;
	float hRatio = size.height / image.size.height;
	float ratio = hRatio > wRatio ? wRatio : hRatio;
	if (image.size.width < size.width && image.size.height < size.height) {
		ratio = 1;
	}
	
	float w = image.size.width * ratio;
	float h = image.size.height * ratio;
	
	return [ImageUtils imageWithImage: image
						 scaledToSize: CGSizeMake(w, h)];
}

+ (UIImage *) imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
	CGImageRef inImage = image.CGImage;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef cgctx = CGBitmapContextCreate(NULL, newSize.width, newSize.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast); 
	if (cgctx == NULL)
    {
        CGColorSpaceRelease( colorSpace );
		printf("cgtx error \n");
		return nil;
	}
	
	size_t w = newSize.width; 
	size_t h = newSize.height;
	CGRect rect = {{0,0},{w,h}}; 
	CGContextDrawImage(cgctx, rect, inImage); 
	CGImageRef imageRef = CGBitmapContextCreateImage (cgctx);
	UIImage *newImage = [UIImage imageWithCGImage: imageRef];
	CGImageRelease(imageRef);
	CGContextRelease(cgctx);
	CGColorSpaceRelease( colorSpace );
	return newImage;
}

+ (UIImage *) partOfImage: (UIImage*) img croppedToSize: (CGSize) size {
	BOOL cropByWidth = img.size.width < img.size.height;
	
	float wRatio = size.width / img.size.width;
	float hRatio = size.height / img.size.height;
	float ratio = cropByWidth ? wRatio : hRatio;
	
	UIImage *croppedImg = [ImageUtils imageWithImage: img 
										scaledToSize: CGSizeMake(img.size.width * ratio, img.size.height * ratio)];
	croppedImg = [ImageUtils croppedImage: croppedImg withRect: CGRectMake(0, 0, size.width, size.height)];
	return croppedImg;
}

+ (UIImage *) imageFromView: (UIView *) view {
	UIGraphicsBeginImageContext(view.bounds.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}


@end