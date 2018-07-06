//
//  OpenCVWrapper.h
//  ibl360
//
//  Created by Daniel Harkness on 30/11/2015.
//  Copyright © 2015 Daniel Harkness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface OpenCVWrapper : NSObject

+ (UIImage*) processHDRWithImageArray:(NSArray*)imageArray timeArray:(NSArray*)timeArray;
+ (UIImage*) processImageWithOpenCV: (UIImage*) inputImage;

+ (UIImage*) processWithOpenCVImage1:(UIImage*)inputImage1 image2:(UIImage*)inputImage2;

+ (UIImage*) processWithArray:(NSArray<UIImage*>*)imageArray;


@end
NS_ASSUME_NONNULL_END
