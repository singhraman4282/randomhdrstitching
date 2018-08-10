//
//  CapturePhotoDelegate.swift
//  CustomCameraMedium
//
//  Created by Raman Singh on 2018-07-03.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit
import AVKit

class CapturePhotoDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    
    var photoData: Data?
    let saveManager = SavePhotoManager()
    var imagesArray = [UIImage]() /*{
        didSet {
            print("total Images: \(imagesArray.count)")
            if imagesArray.count > 1 {
                let stitchedImage:UIImage = OpenCVWrapper.process(with: imagesArray)
                if stitchedImage == stitchedImage {
                    print("good")
                } else {
                    imagesArray.remove(at: imagesArray.count - 1)
                    print("not good")
                }
            }
        }
    }*/
    
    internal func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("CapturePhotoDelegate: didFinishProcessingPhoto")
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            photoData = photo.fileDataRepresentation()
        }
    }
    
    internal func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        print("CapturePhotoDelegate: didFinishCaptureFor")
        guard let photoData = photoData else {
            print("No photo data resource")
            return
        }
        
        let capturedImage = UIImage.init(data: photoData , scale: 1.0)
        
        let resizeManager = ResizeManager()
        let scaledImage = capturedImage!.resizedTo200kB()
        
//        let scaledCaptureImage = resizeManager.resizeImage(image: capturedImage, scaledTo: CGSize(width: (capturedImage?.size.width)!/2, height: (capturedImage?.size.height)!/2))
        
        //SAVE ORIGINAL IMAGE
        
//        saveManager.saveImage(image: scaledCaptureImage)

        imagesArray.append(scaledImage!)
//        imagesArray.append(capturedImage!)
        
        
        
        
//        saveManager.saveImageWithImageData(imageData: photoData)
        
//        let exposureManager = ExposureManager()
//        exposureManager.applyManualExposure(toImage: scaledCaptureImage)
        
    }
    
}


class CapturePhotoDelegate2: NSObject, AVCapturePhotoCaptureDelegate {
    
    var photoData: Data?
    var photoArray = [UIImage]()
    var previouslyStitchedImages = [UIImage]()
    var allCapturedImages = [UIImage]()
    
    internal func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            photoData = photo.fileDataRepresentation()
        }
    }
    
    internal func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        
        guard let photoData = photoData else {
            print("No photo data resource")
            return
        }
        var capturedImage:UIImage?
        capturedImage = UIImage.init(data: photoData , scale: 1.0)?.resized(withPercentage: 0.15)//0.2
        photoArray.append(capturedImage!)
        
        //        allCapturedImages.append(photoArray.last!)
        // allCapturedImages.append(capturedImage!)
        capturedImage = nil
        
    }
    
    
}

extension UIImage {
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedTo200kB() -> UIImage? {
        guard let imageData = UIImagePNGRepresentation(self) else { return nil }
        
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        
        while imageSizeKB > 1000 { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.5),
                let imageData = UIImagePNGRepresentation(resizedImage)
                else { return nil }
            
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        }
        
        print(imageSizeKB)
        return resizingImage
    }
}








/*
 let saveManager = SavePhotoManager()
 saveManager.saveImageWithImageData(imageData: photoData)
 */
