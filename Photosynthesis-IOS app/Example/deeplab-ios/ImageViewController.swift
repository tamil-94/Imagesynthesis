
import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var displayView: UIImageView!
    @IBOutlet weak var testview: UIImageView!
    var testuiimage: UIImage!
    var bgImg: UIImage!
    var fgImg:UIImage!
   
    var imagePicked = 0
     let imagePicker =  UIImagePickerController()
    var sourceImg: UIImage!
    
    var sourceImg1: UIImage!
    var fo: Int!
    var ro: Int!
   // var cgImg: CGImage!
    //var uiimtest: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        displayView.image = sourceImg
        testview.image = sourceImg1
      
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .camera
        displayView.layer.borderColor = UIColor.white.cgColor
        testview.layer.borderColor = UIColor.white.cgColor
            
        displayView.layer.masksToBounds = true
       
        displayView.layer.borderWidth = 2;testview.layer.borderWidth = 2
        displayView.backgroundColor = UIColor.clear
        testview.backgroundColor = UIColor.clear
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
    }

    @IBAction func handlePickerTap(_ sender: Any) {
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func handlePhotoTap(_ sender: UIButton) {
        //let imagePicker =  UIImagePickerController()
        //imagePicker.delegate = self
        //imagePicker.sourceType = .camera
        sender.isHidden = true;
        imagePicked = sender.tag
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func handleSegmentTap(_ sender: Any) {
        
        if let cgImg = sourceImg.segmentation(){
            displayView.image = UIImage(cgImage: cgImg)
        }
    }
    @IBAction func handelMergeTap(_ sender: Any) {
        
        if let cgImg = sourceImg.segmentation(){
        let filter = GraySegmentFilter()
        filter.inputImage = CIImage.init(cgImage: sourceImg.cgImage!)
        filter.maskImage = CIImage.init(cgImage: cgImg)
        let output = filter.value(forKey:kCIOutputImageKey) as! CIImage
        
        let ciContext = CIContext(options: nil)
        let cgImage = ciContext.createCGImage(output, from: output.extent)!
        
        displayView.image = UIImage(cgImage: cgImage)
        
        }
        let bottomImage = testview.image
       
        let topImage = displayView.image

        self.bgImg = bottomImage
        self.fgImg = topImage
        self.performSegue(withIdentifier: "InputVCToDisplayVC", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "InputVCToDisplayVC"){
            if(fgImg != nil) && (bgImg != nil){
         let displayVC = segue.destination as! NewViewController
            
                displayVC.fgImg = fgImg
                displayVC.bgImg = bgImg
                
            }
            else{
                print(" no image")
            }
            
        }
    }
    
    
    @IBAction func handelGrayTap(_ sender: Any) {
        if let cgImg = sourceImg.segmentation(){
            let filter = GraySegmentFilter()
            filter.inputImage = CIImage.init(cgImage: sourceImg.cgImage!)
            filter.maskImage = CIImage.init(cgImage: cgImg)
            let output = filter.value(forKey:kCIOutputImageKey) as! CIImage
            
            let ciContext = CIContext(options: nil)
            let cgImage = ciContext.createCGImage(output, from: output.extent)!
            displayView.image = UIImage(cgImage: cgImage)
        }
    }
    
    
    
}

extension ImageViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            if imagePicked == 1 {
            
                sourceImg = pickedImage.resize(size: CGSize(width: 1200, height: 1200 * (pickedImage.size.height / pickedImage.size.width)))
                
            }
            else if imagePicked == 2 {
                sourceImg1 = pickedImage.resize(size: CGSize(width: 1200, height: 1200 * (pickedImage.size.height / pickedImage.size.width)))
                
            }
            dismiss(animated: true)
            }
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                dismiss(animated: true)
            }
        }
        
 
    
    }
   





















