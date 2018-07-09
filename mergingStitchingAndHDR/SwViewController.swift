//
//  SwViewController.swift
//  CVOpenStitch
//
//  Created by Foundry on 04/06/2014.
//  Copyright (c) 2014 Foundry. All rights reserved.
//

import UIKit

class SwViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var spinner:UIActivityIndicatorView!
    @IBOutlet var imageView:UIImageView?
    @IBOutlet var scrollView:UIScrollView!
    
    //    var imageArray:[UIImage] = [#imageLiteral(resourceName: "p1"),#imageLiteral(resourceName: "p2"),#imageLiteral(resourceName: "p3"),#imageLiteral(resourceName: "p4"),#imageLiteral(resourceName: "p5"),#imageLiteral(resourceName: "p6"),#imageLiteral(resourceName: "p7"),#imageLiteral(resourceName: "p8")]
    
    var imageArray:[UIImage] = [#imageLiteral(resourceName: "p4"),#imageLiteral(resourceName: "p5"),#imageLiteral(resourceName: "p6"),#imageLiteral(resourceName: "p7"),#imageLiteral(resourceName: "p8")]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        stitch()
    }
    
    
    @IBAction func stitchButtonPressed(_ sender: UIButton) {
        
        if imageArray.count > 1 {
            let stitchedImage = stichFromTwoImages(image1: imageArray[0], image2: imageArray[1])
            let imageView:UIImageView = UIImageView.init(image: stitchedImage)
            if self.imageView == self.imageView {
                self.imageView?.removeFromSuperview()
            }
            
            self.imageView = imageView
            self.scrollView.addSubview(self.imageView!)
            self.scrollView.backgroundColor = UIColor.black
            self.scrollView.contentSize = self.imageView!.bounds.size
            self.scrollView.maximumZoomScale = 4.0
            self.scrollView.minimumZoomScale = 0.5
            self.scrollView.delegate = self
            self.scrollView.contentOffset = CGPoint(x: -(self.scrollView.bounds.size.width - self.imageView!.bounds.size.width)/2.0, y: -(self.scrollView.bounds.size.height - self.imageView!.bounds.size.height)/2.0)
            NSLog("scrollview \(self.scrollView.contentSize)")
            
            imageArray.remove(at: 0)
            imageArray.remove(at: 0)
            imageArray.insert(stitchedImage, at: 0)
        }
        
        print("images array total images: \(imageArray.count)")
        
    }
    
    func stitch() {
        self.spinner.startAnimating()
        DispatchQueue.global().async {
            
            let imageArray:[UIImage?] = [#imageLiteral(resourceName: "p1"),#imageLiteral(resourceName: "p2"),#imageLiteral(resourceName: "p3"),#imageLiteral(resourceName: "p4"),#imageLiteral(resourceName: "p5"),#imageLiteral(resourceName: "p6"),#imageLiteral(resourceName: "p7"),#imageLiteral(resourceName: "p8")]
            
            let stitchedImage:UIImage = OpenCVWrapper.process(with: imageArray as! [UIImage]) as UIImage
            
            DispatchQueue.main.async {
                NSLog("stichedImage %@", stitchedImage)
                let imageView:UIImageView = UIImageView.init(image: stitchedImage)
                self.imageView = imageView
                self.scrollView.addSubview(self.imageView!)
                self.scrollView.backgroundColor = UIColor.black
                self.scrollView.contentSize = self.imageView!.bounds.size
                self.scrollView.maximumZoomScale = 4.0
                self.scrollView.minimumZoomScale = 0.5
                self.scrollView.delegate = self
                self.scrollView.contentOffset = CGPoint(x: -(self.scrollView.bounds.size.width - self.imageView!.bounds.size.width)/2.0, y: -(self.scrollView.bounds.size.height - self.imageView!.bounds.size.height)/2.0)
                NSLog("scrollview \(self.scrollView.contentSize)")
                self.spinner.stopAnimating()
            }
        }
    }
    
    func stichFromTwoImages(image1:UIImage, image2:UIImage) -> UIImage {
        let imageArray = [image1, image2]
        let stitchedImage:UIImage = OpenCVWrapper.process(with: imageArray)
        
        return stitchedImage
    }
    
    
    
    
    func viewForZooming(in scrollView:UIScrollView) -> UIView? {
        return self.imageView!
    }
    
}
