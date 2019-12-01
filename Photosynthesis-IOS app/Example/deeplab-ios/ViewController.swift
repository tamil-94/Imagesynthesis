
import UIKit

class ViewController: UIViewController{
    @IBOutlet var chooseImage : UIButton!
    @IBOutlet var takeImage : UIButton!
    @IBOutlet var name : UILabel!
               
    var front_img : UIImage!
    var rear_img : UIImage!
    var count : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.transition(with: name, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.name.textColor = .purple
        }, completion: nil)
        
    }
    

    
    @IBAction func cameraButtonClicked(_ sender: UIButton){
        
        self.performSegue(withIdentifier: "initialtocamera", sender: self)
    }
    
    
    @IBAction func loadImageButton(){
        if(count < 2){
            if (count == 0) {
                    let alert = UIAlertController(title: "Select a foreground image", message: "", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: {_ in self.loadImage()})
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                count = count + 1
                   
            }
            else if(count == 1){
                let alert = UIAlertController(title: "Select a background image", message: "", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style:UIAlertAction.Style.default,handler: {_ in self.loadImage()})
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                count = count + 1
                
            }
            //loadImage()
            //count = count + 1
            //print("func",count)
           
        }
        else if (count == 2){
            count = 0
        }
    }
    
    func loadImage(){
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        //print("inside picker")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "initialtocamera"){
           
            _ = segue.destination as! MainViewController
            
        }
        if(segue.identifier == "initialtoview"){
            if(rear_img != nil) || (front_img != nil){
            //print("inside segue")
            let displayVC = segue.destination as! ImageViewController
            displayVC.sourceImg = self.front_img
            displayVC.sourceImg1 = self.rear_img
           
            }
            else{
                print("error")
            }
            
    }
       
    }

}
extension ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if(count == 1){
                //print("picker",count)
            front_img = pickedImage.resize(size: CGSize(width: 1200, height: 1200 * (pickedImage.size.height / pickedImage.size.width)))
                
             
        }
            else if(count == 2){
                //print("count",count)
                rear_img = pickedImage.resize(size: CGSize(width: 1200, height: 1200 * (pickedImage.size.height / pickedImage.size.width)))
              
                    self.performSegue(withIdentifier: "initialtoview", sender: self)
                
               
            }
 
        picker.dismiss(animated: true, completion: nil)
    }
    
}
}
@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

   
   




