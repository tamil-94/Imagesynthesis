
import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var displayView: UIImageView!
    @IBOutlet weak var testview: UIImageView!
    var testuiimage: UIImage!
    var bgImg: UIImage!
    var fgImg:UIImage!
    var sourceImg: UIImage!
    
    var sourceImg1: UIImage!
    var fo: Int!
    var ro: Int!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        displayView.image = sourceImg
        testview.image = sourceImg1
      
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

    
}
