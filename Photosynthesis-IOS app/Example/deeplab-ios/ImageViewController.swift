
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
    var cgImage : CGImage!
    var cgImg1 : CGImage!
    var buttonselect: Int!
  
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
        //  DispatchQueue.global(qos: .background).async {
          //  self.cgImg1 = self.sourceImg.segmentationback()
        //}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
   
    }
    @IBAction func handleSegmentTap(_ sender: Any) {
        if  self.cgImg1 == nil {
        self.cgImg1 = sourceImg.segmentation()
            displayView.image = UIImage(cgImage: cgImg1)
        }
        else{
             displayView.image = UIImage(cgImage: cgImg1)
        }
        
    }
    @IBAction func handelGrayTap(_ sender: Any) {
        self.buttonselect=2
        if  self.cgImg1 == nil {
            self.cgImg1 = sourceImg.segmentation()
            let filter = GrayFilter()
                filter.inputImage = CIImage.init(cgImage: sourceImg.cgImage!)
            filter.maskImage = CIImage.init(cgImage: self.cgImg1)
                let output = filter.value(forKey:kCIOutputImageKey) as! CIImage
                
                let ciContext = CIContext(options: nil)
                let cgImage = ciContext.createCGImage(output, from: output.extent)!
                displayView.image = UIImage(cgImage: cgImage)
        }
        else{
            
        
            let filter = GrayFilter()
            filter.inputImage = CIImage.init(cgImage: sourceImg.cgImage!)
        filter.maskImage = CIImage.init(cgImage: self.cgImg1)
            let output = filter.value(forKey:kCIOutputImageKey) as! CIImage
            
            let ciContext = CIContext(options: nil)
            let cgImage = ciContext.createCGImage(output, from: output.extent)!
            displayView.image = UIImage(cgImage: cgImage)
        }
        self.bgImg = displayView.image
        self.fgImg = displayView.image
        self.performSegue(withIdentifier: "InputVCToDisplayVC", sender: self)
    }
    

  
    @IBAction func handelMergeTap(_ sender: Any) {
        
        self.buttonselect=1
        
        if  self.cgImg1 == nil {
            
        cgImg1 = sourceImg.segmentation()
        let filter = GraySegmentFilter()
        filter.inputImage = CIImage.init(cgImage: sourceImg.cgImage!)
        filter.maskImage = CIImage.init(cgImage: cgImg1)
        let output = filter.value(forKey:kCIOutputImageKey) as! CIImage
        
        let ciContext = CIContext(options: nil)
        let cgImage = ciContext.createCGImage(output, from: output.extent)!
        
        displayView.image = UIImage(cgImage: cgImage)
        }
        else
        {
            let filter = GraySegmentFilter()
                filter.inputImage = CIImage.init(cgImage: sourceImg.cgImage!)
                filter.maskImage = CIImage.init(cgImage: cgImg1)
                let output = filter.value(forKey:kCIOutputImageKey) as! CIImage
                
                let ciContext = CIContext(options: nil)
                let cgImage = ciContext.createCGImage(output, from: output.extent)!
                
                displayView.image = UIImage(cgImage: cgImage)
        }
        
        self.bgImg = testview.image
        self.fgImg = displayView.image
        self.performSegue(withIdentifier: "InputVCToDisplayVC", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "InputVCToDisplayVC"){
            if(fgImg != nil) && (bgImg != nil){
         let displayVC = segue.destination as! NewViewController
                if (self.buttonselect==1)
                {
                    displayVC.buttonselect = self.buttonselect
                displayVC.fgImg = fgImg
                displayVC.bgImg = bgImg
            }
                else{
                        displayVC.buttonselect = self.buttonselect
                    displayVC.fgImg = bgImg
                    displayVC.bgImg = bgImg
                    
                }
                }
                
            }
            else{
                print(" no image")
            }
            
        }
    }

    

