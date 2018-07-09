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
        let imageArray = [image1, image2]
        let stitchedImage:UIImage = OpenCVWrapper.process(with: imageArray)
        
        return stitchedImage
    }
    
    
}
