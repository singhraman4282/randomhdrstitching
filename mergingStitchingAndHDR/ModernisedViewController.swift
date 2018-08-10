//
//  ModernisedViewController.swift
//  mergingStitchingAndHDR
//
//  Created by Raman Singh on 2018-08-09.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ModernisedViewController: UIViewController {

    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var feedbackImageView: UIImageView!
    
    @IBOutlet var allButtonsCollection: [UIButton]!
    
    
    
    
    let captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    let capturePhotoOutput = AVCapturePhotoOutput()
    let capturePhotoDelegate2 = CapturePhotoDelegate2()
    
    
    
    
    var timer = Timer()
    
    var autoCaptureModeOn = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraUsagePermission()
        if autoCaptureModeOn {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(shoot), userInfo: nil, repeats: true)
        }
    }
    
    @objc func shoot() {
        DispatchQueue.global().async {
            
            let photoSettings = AVCapturePhotoSettings()
            photoSettings.isAutoStillImageStabilizationEnabled = true
            photoSettings.isHighResolutionPhotoEnabled = true
            photoSettings.flashMode = .off
            
            self.capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self.capturePhotoDelegate2)
        }
    }
    
    @IBAction func onTapTakePhoto(_ sender: UIButton) {
        
        if autoCaptureModeOn {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(shoot), userInfo: nil, repeats: true)
        } else {
            DispatchQueue.global().async {
                
                let photoSettings = AVCapturePhotoSettings()
                photoSettings.isAutoStillImageStabilizationEnabled = true
                photoSettings.isHighResolutionPhotoEnabled = true
                photoSettings.flashMode = .off
                
                self.capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self.capturePhotoDelegate2)
            }
        }
    }
    
    @IBAction func undoButtonTapped(_ sender: UIButton) {
        
        if self.capturePhotoDelegate2.previouslyStitchedImages.count > 0 {
            self.capturePhotoDelegate2.previouslyStitchedImages.removeLast()
            if self.capturePhotoDelegate2.previouslyStitchedImages.count != 0 {
                self.feedbackImageView.image = self.capturePhotoDelegate2.previouslyStitchedImages.last
            } else {
                self.feedbackImageView.image = nil
            }
            self.capturePhotoDelegate2.photoArray.removeAll()
        }
        
    }
    
    
    @IBAction func stitichButtonTapped(_ sender: UIButton) {
        
        //        timer.invalidate()
        
        for button in 0..<allButtonsCollection.count {
            allButtonsCollection[button].isHidden = true
        }
        
        DispatchQueue.global().async {
            
            var tempStitchedImage:UIImage?
            
             tempStitchedImage = OpenCVWrapper.process(with: self.capturePhotoDelegate2.photoArray)
            
//            tempStitchedImage = (self.cvmanager!.stitch(withOpenCV: self.capturePhotoDelegate2.photoArray))
            
            if tempStitchedImage != nil {
                
                DispatchQueue.main.async {
                    self.feedbackImageView.image = tempStitchedImage!
                    for button in 0..<self.allButtonsCollection.count {
                        self.allButtonsCollection[button].isHidden = false
                    }
                }
                
                UIImageWriteToSavedPhotosAlbum(self.rotateImageAppropriately(tempStitchedImage!)!, nil, nil, nil)
                self.capturePhotoDelegate2.photoArray.removeAll()
                self.capturePhotoDelegate2.previouslyStitchedImages.append(tempStitchedImage!)
                print("Stitching Successful")
                tempStitchedImage = nil
            } else {
                self.capturePhotoDelegate2.photoArray.removeAll()
                print("FAILED TO STITCH")
                
                DispatchQueue.main.async {
                    for button in 0..<self.allButtonsCollection.count {
                        self.allButtonsCollection[button].isHidden = false
                    }
                }
            }
        }
    }
    
    @IBAction func stitchAllStitchedImages(_ sender: UIButton) {
        
        for button in 0..<allButtonsCollection.count {
            allButtonsCollection[button].isHidden = true
        }
        
        print("Stitching all images")
        
        DispatchQueue.global().async {
            var tempStitchedImage:UIImage?
            
            tempStitchedImage = OpenCVWrapper.process(with: self.capturePhotoDelegate2.previouslyStitchedImages)
            
//            tempStitchedImage = (self.cvmanager!.stitch(withOpenCV: self.capturePhotoDelegate2.previouslyStitchedImages/*.resizeAllImages(withPercentage: 0.5)*/))
            
            if tempStitchedImage != nil {
                
                DispatchQueue.main.async {
                    for button in 0..<self.allButtonsCollection.count {
                        self.allButtonsCollection[button].isHidden = false
                    }
                    self.feedbackImageView.image = tempStitchedImage!
                }
                
                UIImageWriteToSavedPhotosAlbum(tempStitchedImage!, nil, nil, nil)
                //                self.capturePhotoDelegate2.previouslyStitchedImages.append(tempStitchedImage!)
                print("Stitched Images Successfully Stitched")
            } else {
                print("STITCHED IMAGES FAILED TO STITCH")
                
                DispatchQueue.main.async {
                    for button in 0..<self.allButtonsCollection.count {
                        self.allButtonsCollection[button].isHidden = false
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func stitchFromAllCapturedImages(_ sender: UIButton) {
        
        //        for button in 0..<allButtonsCollection.count {
        //            allButtonsCollection[button].isHidden = true
        //        }
        
        self.capturePhotoDelegate2.previouslyStitchedImages.removeAll()
        
        guard let feedbackImage = self.feedbackImageView.image else { return }
        
        self.capturePhotoDelegate2.previouslyStitchedImages.append(feedbackImage)
        
        
        /*
         DispatchQueue.global().async {
         var tempStitchedImage:UIImage?
         tempStitchedImage = (self.cvmanager!.stitch(withOpenCV: self.capturePhotoDelegate2.allCapturedImages))
         
         if tempStitchedImage != nil {
         
         DispatchQueue.main.async {
         for button in 0..<self.allButtonsCollection.count {
         self.allButtonsCollection[button].isHidden = false
         }
         self.feedbackImageView.image = tempStitchedImage!
         }
         
         UIImageWriteToSavedPhotosAlbum(self.rotateImageAppropriately(tempStitchedImage!)!, nil, nil, nil)
         self.capturePhotoDelegate2.previouslyStitchedImages.append(tempStitchedImage!)
         print("Stitching from all captured images Successful")
         } else {
         self.capturePhotoDelegate2.photoArray.removeAll()
         print("FAILED TO STITCH")
         
         DispatchQueue.main.async {
         for button in 0..<self.allButtonsCollection.count {
         self.allButtonsCollection[button].isHidden = false
         }
         }
         }
         }
         */
        
    }
    
    
    
    func checkCameraUsagePermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.initialiseCaptureSession()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.initialiseCaptureSession()
                }
            }
        case .denied:
            return
        case .restricted:
            return
        }
    }
    
    func initialiseCaptureSession() {
        
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice!),
            captureSession.canAddInput(input)
            else { return }
        
        captureSession.addInput(input)
        self.previewView.videoPreviewLayer.session = self.captureSession
        self.previewView.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        capturePhotoOutput.isHighResolutionCaptureEnabled = true
        captureSession.addOutput(capturePhotoOutput)
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        captureSession.startRunning()
    }
    
    private func rotateImageAppropriately(_ imageToRotate: UIImage?) -> UIImage? {
        var properlyRotatedImage: UIImage?
        let imageRef = imageToRotate?.cgImage
        if let aRef = imageRef, let anOrientation = UIImageOrientation(rawValue: 2) {
            properlyRotatedImage = UIImage(cgImage: aRef, scale: 1.0, orientation: anOrientation)
        }
        
        return properlyRotatedImage
    }
}
