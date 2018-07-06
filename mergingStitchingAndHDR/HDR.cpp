//
//  HDR.cpp
//  ibl360
//
//  Created by Daniel Harkness on 30/11/2015.
//  Copyright © 2015 Daniel Harkness. All rights reserved.
//

#include "HDR.hpp"

#include <opencv2/photo.hpp>
#include "opencv2/imgcodecs.hpp"
#include <opencv2/highgui.hpp>
#include <vector>
#include <iostream>
#include <fstream>

using namespace cv;
using namespace std;

vector<Mat> imgs2;

    cv::Mat mergeToHDR (vector<Mat>& images, vector<float>& times)
    {
        imgs2 = images;
        Mat response;
        //Ptr<CalibrateDebevec> calibrate = createCalibrateDebevec();
        //calibrate->process(images, response, times);
        
        Ptr<CalibrateRobertson> calibrate = createCalibrateRobertson();
        calibrate->process(images, response, times);
        
        // create HDR
        Mat hdr;
        Ptr<MergeDebevec> merge_debevec = createMergeDebevec();
        merge_debevec->process(images, hdr, times, response);
        
        // create LDR
        Mat ldr;
        Ptr<TonemapDurand> tonemap = createTonemapDurand(2.2f);
        tonemap->process(hdr, ldr);
        
        // create fusion
        Mat fusion;
        Ptr<MergeMertens> merge_mertens = createMergeMertens();
        merge_mertens->process(images, fusion);
        
        /*
         Uncomment what kind of tonemapped image or hdr to return
         Convert back to 8-bits per channel because that is what
         the UIImage+OpenCV class extension is expecting
        */
        
        
        // tone mapped
        /*
        Mat ldr8bit;
        ldr = ldr * 255;
        ldr.convertTo(ldr8bit, CV_8U);
        return ldr8bit;
        */
        
        // fusion
        Mat fusion8bit;
        fusion = fusion * 255;
        fusion.convertTo(fusion8bit, CV_8U);
        return fusion8bit;
        
        // hdr
        /*
        Mat hdr8bit;
        hdr = hdr * 255;
        hdr.convertTo(hdr8bit, CV_8U);
        return hdr8bit;
        */
    }
