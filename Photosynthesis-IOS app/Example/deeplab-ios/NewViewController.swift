

import AVFoundation
import UIKit


class NewViewController: UIViewController, UIDropInteractionDelegate, UIDragInteractionDelegate,UIGestureRecognizerDelegate {
    var bgImg: UIImage!
    var fgImg : UIImage!
    var identity = CGAffineTransform.identity
    var imageView1 : UIImageView!
    var draggedwidth = 300
    var draggedheight = 350
    var dragsize: CGSize!
    @IBOutlet var save : UIButton!
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let touchedPoint = session.location(in: self.view)
        if let touchedImageView = self.view.hitTest(touchedPoint, with: nil) as? UIImageView {
            
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
                       self.view.addSubview(imageView)
                    imageView.frame = CGRect(x: 0, y: 0, width: self.dragsize.width, height: self.dragsize.height)
                       imageView.addInteraction(dragdelegate)
                    imageView.addGestureRecognizer(pinchGesture)
                       
                       let centerPoint = session.location(in: self.view)
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
        
        self.view.addInteraction(UIDropInteraction(delegate: self))
        self.view.addInteraction(UIDragInteraction(delegate: self))
        self.view.addGestureRecognizer(pinchGesture)
        DispatchQueue.main.async {

            let imageView = UIImageView(image: self.bgImg)
            imageView.isUserInteractionEnabled = true
            self.view.addSubview(imageView)
            imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height-80)
            imageView.contentMode = .scaleAspectFit
            let bgsize = imageView.getScaledImageSize()
            let bgwidth = bgsize?.size.width
            //print("background image width")
            //print(bgwidth)
            let bgheight = bgsize?.size.height
            let ypoint = ((self.view.bounds.height/2)+(bgheight!/2)-bgheight!/2)
            let xpoint = (bgwidth!/2)-(300/2)
            self.imageView1 = UIImageView(image: self.fgImg)
            
                                
            imageView.addSubview(self.imageView1)
            self.imageView1.contentMode = .scaleAspectFit
            self.imageView1.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height-80)
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
            
            
        }
       
        
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @IBAction func saveButtonClicked(){
        print("button clicked")
    }
}
extension UIImageView {
   
    func getScaledImageSize() -> CGRect? {
        if let image = self.image {
            return AVMakeRect(aspectRatio: image.size, insideRect: self.frame);
        }

        return nil;
    }
}


