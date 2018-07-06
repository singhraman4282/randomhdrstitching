//
//  SavePhotoManager.swift
//  CustomCameraMedium
//
//  Created by Raman Singh on 2018-07-04.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit

class SavePhotoManager: NSObject {
    

    func saveImageWithImageData(imageData:Data) {
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    func saveImage(image:UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
}
