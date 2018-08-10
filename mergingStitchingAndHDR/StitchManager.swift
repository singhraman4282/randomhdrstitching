//
//  StitchManager.swift
//  mergingStitchingAndHDR
//
//  Created by Raman Singh on 2018-07-06.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit

class StitchManager: NSObject {
    
   

    func stichFromTwoImages(image1:UIImage, image2:UIImage) -> UIImage {
        let imagesArray = [image1, image2]
        let stitchedImage:UIImage = OpenCVWrapper.process(with: imagesArray)
        return stitchedImage
    }
    
    func stitchImageFromImagesArray(imagesArray:[UIImage]) ->UIImage {
        let stitchedImage:UIImage = OpenCVWrapper.process(with: imagesArray)
        return stitchedImage
    }
    
    
}
