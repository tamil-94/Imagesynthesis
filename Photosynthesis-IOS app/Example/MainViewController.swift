//
//  MainViewController.swift
//  PhotoSynthesis
//
//  Created by Mithun on 10/19/19.
//  Copyright © 2019 xyh. All rights reserved.
//

import UIKit
import Photos


class MainViewController: UIViewController {
    @IBOutlet var takePhotoButton : UIButton!
    @IBOutlet var cameraPreview : UIImageView!
    @IBOutlet var toggleCameraButton: UIButton!
    @IBOutlet var toggleFlashButton: UIButton!
    var front_img: UIImage!
    
    //var front_img = fixedOrientation(front_img1)
    var rear_img: UIImage!
    var count: Int=0
    let cameraController = CameraController()
    var orientationint: Int=0
    var foreorientation: Int=0
    var rearorientation: Int=0
    override var prefersStatusBarHidden: Bool { return true }

}
extension MainViewController {
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        if UIDevice.current.orientation.isLandscape{
            self.orientationint = 1
        }
        else{
            self.orientationint = 0
        }
        func configureCameraController() {
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.cameraPreview)
 
                
            }
        }
        
        func styleCaptureButton() {
            takePhotoButton.layer.borderColor = UIColor.black.cgColor
            takePhotoButton.layer.borderWidth = 2
            
            takePhotoButton.layer.cornerRadius = min(takePhotoButton.frame.width, takePhotoButton.frame.height) / 2
        }
        
        styleCaptureButton()
        configureCameraController()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
          UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        if UIDevice.current.orientation.isLandscape{
                  self.orientationint = 1
              }
              else{
                  self.orientationint = 0
              }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
         NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        if UIDevice.current.orientation.isLandscape{
                  self.orientationint = 1
              }
              else{
                  self.orientationint = 0
              }
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        if UIDevice.current.orientation.isLandscape{
                  self.orientationint = 1
              }
              else{
                  self.orientationint = 0
              }
    }
    
    @objc func deviceRotated(){
        if UIDevice.current.orientation.isLandscape{
            self.orientationint = 1
            
        }
        else{
            self.orientationint = 0
        }
    }
    @objc func callseg(){
        if(self.rear_img != nil) && (self.front_img != nil){
                                                            
            print (self.count)
            print ("came in")
            self.performSegue(withIdentifier: "cameratoview", sender: self)
        }
    }
}
extension MainViewController{
    @IBAction func toggleFlash(_sender:UIButton){
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            toggleFlashButton.setImage(#imageLiteral(resourceName: "flashlight.off.fill"), for: .normal)
        }
            
        else {
            cameraController.flashMode = .on
            toggleFlashButton.setImage(#imageLiteral(resourceName: "flashlight.on.fill"), for: .normal)
        }
    }
    @IBAction func switchCameras(_ sender: UIButton) {
            do {
                try cameraController.switchCameras()
            }
                
            catch {
                print(error)
            }
        }
        @IBAction func captureImage(_ sender: UIButton) {
            //print("step 0")
                //print("inside test front")
            let timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
            
        //print("in timer function")
            //print("self count value")
   if self.count==2{
    timer.invalidate()
     callseg()
   }
    }
    
    @objc func fireTimer(timer: Timer ) {
    
    //print("Timer fired!")
    
                //self.cameraController.
            if cameraController.currentCameraPosition  == .front{
                //print("inside test front")
             cameraController.captureImage {(image, error) in
                           guard let image = image else {
                               print(error ?? "Image capture error")
                               return
                           }
                
                let sizetest = UIScreen.main.bounds.size
                let currentDevice: UIDevice = UIDevice.current
                let orientation: UIDeviceOrientation = currentDevice.orientation
                
                if UIDevice.current.orientation.isLandscape {
                    print("inside if landscape")
                }
                if UIDevice.current.orientation.isPortrait{
                    print("inside if portrait")
                }
                if (self.orientationint==0){
                    print("Portrait: \(sizetest.width) X \(sizetest.height)")
                    self.front_img = image.rotate()
                    self.foreorientation = 0
                }else{
                 print("Landscape: \(sizetest.width) X \(sizetest.height)")
                self.front_img = image.rotate90(radians: .pi/2)
                    self.foreorientation = 1
                }
                //print("first entry")
                do {try self.cameraController.switchCameras()
                }catch {print(error)}
                self.count=self.count+1
               let shutterView = UIView(frame: self.cameraPreview.frame)
                              shutterView.backgroundColor = UIColor.black
                              self.view.addSubview(shutterView)
                              UIView.animate(withDuration: 0.3, animations: {
                                  shutterView.alpha = 0
                              }, completion: { (_) in
                                  shutterView.removeFromSuperview()
                              })
                }
                
                //print("test print")
            }
    
     if cameraController.currentCameraPosition  == .rear{
    self.cameraController.captureImage {(imaget, error) in
                              guard let imaget = imaget else {
                                  print(error ?? "Image capture error")
                                  return
                              }
    
     if (self.orientationint==0){
                                   self.rear_img = imaget
                    self.rearorientation = 0
                               }else{
                    var photo = imaget.rotate90(radians: .pi/2)
                    photo = photo.rotate90(radians: .pi/2)
                    self.rear_img = photo.rotate90(radians: .pi/2)
                    self.rearorientation = 1
                               }
        self.count=self.count+1
        
        let shutterView = UIView(frame: self.cameraPreview.frame)
                           shutterView.backgroundColor = UIColor.black
                           self.view.addSubview(shutterView)
                           UIView.animate(withDuration: 0.3, animations: {
                               shutterView.alpha = 0
                           }, completion: { (_) in
                               shutterView.removeFromSuperview()
                           })
     }
        if self.count==2{
               //print("print count inside rear 2")
                 timer.invalidate()
               callseg()
           }
           
    }
/*
    if self.count==2{
        print("print count 2")
          timer.invalidate()
        callseg()
    }
   
 */
    }
                
                  

            
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "cameratoview"){
            if(rear_img != nil) || (front_img != nil){
                //print("inside segue")
               let displayVC = segue.destination as! ImageViewController
               displayVC.sourceImg = self.front_img
                displayVC.sourceImg1 = self.rear_img
               
                displayVC.fo = self.foreorientation
                displayVC.ro = self.rearorientation
               
            }
            else{
                print(" no image")
            }
            
        }
    }
        
    }

extension UIImage {

    func rotate() -> UIImage? {
        
        guard imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }

        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
          
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            //transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
             
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
           
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}
extension UIImage {
    func rotate90(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}
extension UIImage {

    func rotatetest() -> UIImage? {
        
    
        
        let uiimagereturn: UIImage = self.copy() as! UIImage
        
        if (uiimagereturn.size.width > uiimagereturn.size.height)
            
        {
            return uiimagereturn.rotate90(radians: .pi/2)
        
        }
        return uiimagereturn
    }
}

