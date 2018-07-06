//
//  PreviewView.swift
//  CustomCameraMedium
//
//  Created by Raman Singh on 2018-07-03.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit
import AVKit

class PreviewView: UIView {
   
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

}
