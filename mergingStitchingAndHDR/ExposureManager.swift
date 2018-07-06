//
//  ExposureManager.swift
//  CustomCameraMedium
//
//  Created by Raman Singh on 2018-07-04.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit
import CoreImage

class ExposureManager: NSObject {
    
    
    private var returnedImage:UIImage!
    
    
    private let times: [Float] = [1/1, 1/2, 1/4, 1/8, 1/16, 1/32, 1/64]
    private var imagesArray = [UIImage]() {
        didSet {
            if imagesArray.count == 7 {
                makeHDRfromImages(completion:  { () -> (Void) in
                    let saveManager = SavePhotoManager()
//                    saveManager.saveImage(image: self.rotateImageAppropriately(self.returnedImage)!)
                    saveManager.saveImage(image: self.returnedImage)
                    print("Done")
                })
            }
        }
    }
    
    
    func applyManualExposure(toImage image:UIImage) {
        
        for exposureValue in -3...3 {
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: image)
            let filter = CIFilter(name: "CIExposureAdjust")
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            filter!.setValue(exposureValue, forKey: kCIInputEVKey)
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let returnImage = UIImage(cgImage: filteredImageRef!)
            imagesArray.append(returnImage)
        }
        
    }
    
    private func makeHDRfromImages(completion: @escaping ()->(Void)) {
        let image = OpenCVWrapper.processHDR(withImageArray: imagesArray, time: times)
        returnedImage = image
        DispatchQueue.main.async {
            completion()
        }
    }
    
    private func rotateImageAppropriately(_ imageToRotate: UIImage?) -> UIImage? {
        var properlyRotatedImage: UIImage?
        let imageRef = imageToRotate?.cgImage
        if let aRef = imageRef, let anOrientation = UIImageOrientation(rawValue: 3) {
            properlyRotatedImage = UIImage(cgImage: aRef, scale: 1.0, orientation: anOrientation)
        }
        
        return properlyRotatedImage
    }
    
    
    
}
