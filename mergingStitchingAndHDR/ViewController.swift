//
//  ViewController.swift
//  podHDRwithOpenCV
//
//  Created by Raman Singh on 2018-07-05.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController {
    
    
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var previewView: PreviewView!
    
    let captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    let capturePhotoOutput = AVCapturePhotoOutput()
    let capturePhotoDelegate = CapturePhotoDelegate()
    
    var imageToExpose:UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraUsagePermission()
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
        print("capturePhotoOutput.maxBracketedCapturePhotoCount is \(capturePhotoOutput.maxBracketedCapturePhotoCount)")
        captureSession.startRunning()
    }
    
    @IBAction func onTapTakePhoto(_ sender: UIButton) {
        feedbackLabel.text = "stitching"
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .off
        
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: capturePhotoDelegate)
        
        if capturePhotoDelegate.imagesArray.count>2 {
            print("total Images: \(capturePhotoDelegate.imagesArray.count)")
            let stitchedImage:UIImage = OpenCVWrapper.process(with: capturePhotoDelegate.imagesArray)
            if stitchedImage == stitchedImage {
                feedbackLabel.text = "good"
                print("good")
            } else {
                capturePhotoDelegate.imagesArray.remove(at: capturePhotoDelegate.imagesArray.count - 1)
                feedbackLabel.text = "not good"
                print("not good")
            }
        }
        
    }
    
    @IBAction func onTapCreatePanorama(_ sender: UIButton) {
        
        let stitchedImage:UIImage = OpenCVWrapper.process(with: capturePhotoDelegate.imagesArray)
        
        if stitchedImage == stitchedImage {
            feedbackLabel.text = "good"
            print("good")
        } else {
            feedbackLabel.text = "not good"
            print("not good")
        }
        
        
        let savePhotoManager = SavePhotoManager()
        savePhotoManager.saveImage(image: stitchedImage)

        
//        capturePhotoDelegate.imagesArray = [UIImage]()
        imageToExpose = stitchedImage
        
    }
    
    
    @IBAction func makeHDR(_ sender: UIButton) {
        if imageToExpose == imageToExpose {
            let exposureManager = ExposureManager()
            exposureManager.applyManualExposure(toImage: imageToExpose)
        } else {
            print("still stitching")
        }
        
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
    
}
