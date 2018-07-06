//
//  OpenCVWrapper.mm
//  ibl360
//
//  Created by Daniel Harkness on 30/11/2015.
//  Copyright © 2015 Daniel Harkness. All rights reserved.
//

#import "OpenCVWrapper.h"
#import "UIImage+OpenCV.h"
#import "UIImage+Rotate.h"
#import "HDR.hpp"
#import "stitching.h"

@implementation OpenCVWrapper

+ (UIImage*) processHDRWithImageArray:(NSArray*)imageArray timeArray:(NSArray*)timeArray
{
    if ([imageArray count]==0){
        NSLog (@"imageArray is empty");
        return nil;
    }
    std::vector<cv::Mat> matImages;
    std::vector<float> times;
    
    for (id image in imageArray) {
        if ([image isKindOfClass: [UIImage class]]) {
            /*
             All images taken with the iPhone/iPa cameras are LANDSCAPE LEFT orientation. The  UIImage imageOrientation flag is an instruction to the OS to transform the image during display only. When we feed images into openCV, they need to be the actual orientation that we expect them to be for stitching. So we rotate the actual pixel matrix here if required.
             */
            UIImage* rotatedImage = [image rotateToImageOrientation];
            cv::Mat matImage = [rotatedImage CVMat3];
            NSLog (@"matImage: %@",image);
            matImages.push_back(matImage);
        }
    }
    
    for (id time in timeArray) {
        if ([time isKindOfClass: [NSNumber class]]) {
            times.push_back([time floatValue]);
        }
    }
    
    NSLog (@"merging to HDR...");
    
    cv::Mat HDRMat =  mergeToHDR(matImages, times);
    UIImage* result =  [UIImage imageWithCVMat:HDRMat];
    return result;
}

//STITCHING METHODS


+ (UIImage*) processImageWithOpenCV: (UIImage*) inputImage
{
    NSArray* imageArray = [NSArray arrayWithObject:inputImage];
    UIImage* result = [[self class] processWithArray:imageArray];
    return result;
}

+ (UIImage*) processWithOpenCVImage1:(UIImage*)inputImage1 image2:(UIImage*)inputImage2;
{
    NSArray* imageArray = [NSArray arrayWithObjects:inputImage1,inputImage2,nil];
    UIImage* result = [[self class] processWithArray:imageArray];
    return result;
}

+ (UIImage*) processWithArray:(NSArray*)imageArray
{
    if ([imageArray count]==0){
        NSLog (@"imageArray is empty");
        return 0;
    }
    std::vector<cv::Mat> matImages;
    
    for (id image in imageArray) {
        if ([image isKindOfClass: [UIImage class]]) {
            UIImage* rotatedImage = [image rotateToImageOrientation];
            cv::Mat matImage = [rotatedImage CVMat3];
            NSLog (@"matImage: %@",image);
            matImages.push_back(matImage);
        }
    }
    NSLog (@"stitching...");
    cv::Mat stitchedMat = stitch (matImages);
    UIImage* result =  [UIImage imageWithCVMat:stitchedMat];
    return result;
}


@end
