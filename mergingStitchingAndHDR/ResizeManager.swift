//
//  ResizeManager.swift
//  CustomCameraMedium
//
//  Created by Raman Singh on 2018-07-05.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit

class ResizeManager: NSObject {
    
    
    func resizeImage(image: UIImage?, scaledTo newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
