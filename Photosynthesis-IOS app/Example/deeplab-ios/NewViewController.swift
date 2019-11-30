//
//  NewViewController.swift
//  PhotoSynthesis
//
//  Created by Mithun on 10/7/19.
//  Copyright © 2019 xyh. All rights reserved.
//

import AVFoundation
import UIKit


class NewViewController: UIViewController, UIDropInteractionDelegate, UIDragInteractionDelegate,UIGestureRecognizerDelegate {
    var bgImg: UIImage!
    var fgImg : UIImage!
    var buttonselect : Int!
    var identity = CGAffineTransform.identity
    var imageView1 : UIImageView!
    var draggedwidth = 300
    var draggedheight = 350
    var dragsize: CGSize!
    var fgxpoint = CGFloat(0)
    var bgy = CGFloat(0)
    var img : UIImage!
    var fgorientation : Int!
    var bgorientation : Int!
    @IBOutlet var save : UIButton!
    @IBOutlet var share : UIButton!
    @IBOutlet var ImgView : UIView!
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let touchedPoint = session.location(in: self.ImgView)
        if let touchedImageView = self.ImgView.hitTest(touchedPoint, with: nil) as? UIImageView {
            
            let touchedImage = touchedImageView.image
            
            let itemProvider = NSItemProvider(object: touchedImage!)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = touchedImageView
            return [dragItem]
        }
        
        return []
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        animator.addCompletion { (position) in
            if position == .end {
                session.items.forEach { (dragItem) in
                    if let touchedImageView = dragItem.localObject as? UIView {
                     touchedImageView.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        return UITargetedDragPreview(view: item.localObject as! UIView)
    }
    
    /////
   
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
           let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale))
           for dragItem in session.items {
               dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (obj, err) in
                   
                   if let err = err {
                       print("Failed to load our dragged item:", err)
                       return
                   }
                   
                   guard let draggedImage = obj as? UIImage else { return }
                   let dragdelegate = UIDragInteraction(delegate: self)
                   dragdelegate.isEnabled = true
                   
                   DispatchQueue.main.async {
                       let imageView = UIImageView(image: draggedImage)
                       imageView.isUserInteractionEnabled = true
                       self.ImgView.addSubview(imageView)
                    imageView.frame = CGRect(x: 0, y: 0, width: self.dragsize.width, height: self.dragsize.height)
                       imageView.addInteraction(dragdelegate)
                    imageView.addGestureRecognizer(pinchGesture)
                       
                       let centerPoint = session.location(in: self.ImgView)
                       imageView.center = centerPoint
                   }
                   
               })
           }
       }
       
       func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
           return UIDropProposal(operation: .copy)
       }
       
       func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
           return session.canLoadObjects(ofClass: UIImage.self)
       }
    @objc func scale(_ gesture:UIPinchGestureRecognizer){
        
        switch gesture.state {
        case .began:
            identity = gesture.view!.transform
        case .changed,.ended:
            gesture.view!.transform = identity.scaledBy(x: gesture.scale, y: gesture.scale)
            self.dragsize=gesture.view!.frame.size
            //print("printing drag size width")
            //print(dragsize.width)
            //imageView1.frame = CGRect(x:0,y:0,width:self.imageView1.bounds.width, height:self.imageView1.bounds.height)
            
        case .cancelled:
            break
        default:
            break
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        let dragdelegate = UIDragInteraction(delegate: self)
        dragdelegate.isEnabled = true
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scale))
        
        self.ImgView.addInteraction(UIDropInteraction(delegate: self))
        self.ImgView.addInteraction(UIDragInteraction(delegate: self))
        self.ImgView.addGestureRecognizer(pinchGesture)
        DispatchQueue.main.async {

            let imageView = UIImageView(image: self.bgImg)
            imageView.isUserInteractionEnabled = true
            self.ImgView.addSubview(imageView)
            imageView.frame = CGRect(x: 0, y: 0, width: self.ImgView.bounds.width, height: self.ImgView.bounds.height-80)
            imageView.contentMode = .scaleAspectFit
            
            if (self.buttonselect==1)
            {
            
            let bgsize = imageView.getScaledImageSize()
            let bgwidth = bgsize?.size.width
            let bgheight1 = bgsize?.size.height
            print("background image width & height")
            print(self.bgImg.size.width)
            print(self.bgImg.size.height)
            
            print("scaled background image width & height")
            print(bgwidth!)
            
            print(bgheight1!)
            
            self.imageView1 = UIImageView(image: self.fgImg)
            
            if(self.fgImg.size.width > self.fgImg.size.height){
                print("Landscape mode")
                self.fgorientation=1
            }
            else if(self.fgImg.size.width < self.fgImg.size.height){
                print("Portrait mode")
                 self.fgorientation=0
            }
            if(self.bgImg.size.width > self.bgImg.size.height){
                print("Landscape background")
                 self.bgorientation=1
            }
            else{
                print("Portrait background")
                 self.bgorientation=0
            }
            let bgscaledxpoint = imageView.contentClippingRect()
            let bgx = bgscaledxpoint?.minX
            self.bgy = bgscaledxpoint!.minY
            print("bgx",bgx!)
            print("bgy",self.bgy)
            let fgratio = self.fgImg.size.width/self.fgImg.size.height
            let fgwidth1 = fgratio * bgheight1!
            self.fgxpoint = (bgwidth!/2) - (fgwidth1/2)
                                
            imageView.addSubview(self.imageView1)
            self.imageView1.contentMode = .scaleAspectFit
            //self.imageView1.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height-80)
            if (self.fgorientation==self.bgorientation){
                self.imageView1.frame = CGRect(x: bgx!, y: self.bgy, width: bgwidth!, height: bgheight1!)
            }
            else {
                if(self.bgorientation==1){
                    self.imageView1.frame = CGRect(x: self.fgxpoint, y: self.bgy, width: fgwidth1, height: bgheight1!)
                }
                else{
                    self.bgy = bgscaledxpoint!.maxY
                    
                    let fgnewheight = bgwidth!/fgratio
                    let fgnewypoint = self.bgy-fgnewheight
                    self.imageView1.frame = CGRect(x: bgx!, y:fgnewypoint , width: bgwidth!, height: fgnewheight)
                    
                }
            }
            
            //self.imageView1.frame = CGRect(x: self.fgxpoint, y: self.bgy, width: fgwidth1, height: bgheight1!)
            
            //self.dragsize.width = 300
            //self.dragsize.height = 350
            let fgsize = self.imageView1.getScaledImageSize()
            let fgwidth = fgsize?.size.width
            //print("background image width")
            //print(bgwidth)
            let fgheight = fgsize?.size.height
            self.dragsize = CGSize(width: fgwidth!, height: fgheight!)
            self.imageView1.addInteraction(dragdelegate)
            self.imageView1.addInteraction(UIDropInteraction(delegate: self))
            self.imageView1.isUserInteractionEnabled = true
            self.imageView1.addGestureRecognizer(pinchGesture)
            
        /////
        }
        ///////
            
            
        }
       
        
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @IBAction func saveButtonClicked(){
        print("button clicked")
        self.img = ImgView.takeScreenshot()
        print("image taken")
        
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to photo album.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    @IBAction func shareButtonClicked(sender: UIButton) {
        let textToShare = "Hey! Look what i made with Photo-synthesis app"
        let imageToShare : UIImage = ImgView.takeScreenshot()
        //print(imageToShare)
        
            let objectsToShare = [textToShare, imageToShare] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
     
            //New Excluded Activities Code
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.addToReadingList]
                 
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        
    }
}
extension UIImageView {
    /// Retrieve the scaled size of the image within this ImageView.
    /// - Returns: A CGRect representing the size of the image after scaling or nil if no image is set.
        func getScaledImageSize() -> CGRect? {
        if let image = self.image {
            return AVMakeRect(aspectRatio: image.size, insideRect: self.frame);
        }

         return nil;
    }
    
        func contentClippingRect() -> CGRect? {
            guard let image = image else { return bounds }
            guard contentMode == .scaleAspectFit else { return bounds }
            guard image.size.width > 0 && image.size.height > 0 else { return bounds }

            let scale: CGFloat
            if image.size.width > image.size.height {
                scale = bounds.width / image.size.width
            } else {
                scale = bounds.height / image.size.height
            }

            let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            let x = (bounds.width - size.width) / 2.0
            let y = (bounds.height - size.height) / 2.0

            return CGRect(x: x, y: y, width: size.width, height: size.height)
        }
    
}
extension UIView {

    func takeScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}


