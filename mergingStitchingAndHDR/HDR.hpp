//
//  HDR.hpp
//  ibl360
//
//  Created by Daniel Harkness on 30/11/2015.
//  Copyright © 2015 Daniel Harkness. All rights reserved.
//

#ifndef HDR_hpp
#define HDR_hpp

#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

cv::Mat mergeToHDR (vector<Mat>& images, vector<float>& times);

#endif /* HDR_hpp */
