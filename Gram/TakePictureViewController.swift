//
//  TakePictureViewController.swift
//  Gram
//
//  Created by Sumedha Mehta on 6/20/16.
//  Copyright © 2016 Sumedha Mehta. All rights reserved.
//

import UIKit
import Parse

class TakePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var currImage: UIImage?
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var chooseImgLabel: UIButton!
    
    
    @IBOutlet weak var filter1: UIImageView!
    @IBOutlet weak var filter2: UIImageView!
    @IBOutlet weak var filter3: UIImageView!
    @IBOutlet weak var filter4: UIImageView!
    @IBOutlet weak var filter5: UIImageView!
    @IBOutlet weak var filter6: UIImageView!
    @IBOutlet weak var filter7: UIImageView!
    @IBOutlet weak var filter8: UIImageView!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button8: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapTakePicture(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        selectedImage.image = editedImage

    
        // Do something with the images (based on your use case)
        setUpImages(editedImage)
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
        if(selectedImage.image != nil) {
            captionField.hidden = false
            chooseImgLabel.hidden = true
        }
    }
    
    
    
    
    
    @IBAction func onTapLoad(sender: AnyObject) {
        
        if selectedImage.image  != nil {
            print(selectedImage.image)
            let image = selectedImage.image
            let caption = captionField.text as String!
            Post.postUserImage(image!, withCaption: caption, withCompletion: nil)
            performSegueWithIdentifier("loadPictureSegue", sender: nil)
        }
        
    }
        
    func setUpImages(image: UIImage) {
        let originalImage = CIImage(image: image)
        let cifilter1 = CIFilter(name: "CIPhotoEffectMono")
        cifilter1!.setDefaults()
        cifilter1!.setValue(originalImage, forKey: kCIInputImageKey)
        let outputImage1 = cifilter1!.outputImage
        let newImage = UIImage(CIImage: outputImage1!)
        filter1.image = newImage
        
        let cifilter2 = CIFilter(name: "CIPhotoEffectInstant")
        cifilter2!.setDefaults()
        cifilter2!.setValue(originalImage, forKey: kCIInputImageKey)
        let outputImage2 = cifilter2!.outputImage
        let newImage2 = UIImage(CIImage: outputImage2!)
        filter2.image = newImage2
        currImage = newImage2
        
        let cifilter3 = CIFilter(name: "CIPhotoEffectTonal")
        cifilter3!.setDefaults()
        cifilter3!.setValue(originalImage, forKey: kCIInputImageKey)
        let outputImage3 = cifilter3!.outputImage
        let newImage3 = UIImage(CIImage: outputImage3!)
        filter3.image = newImage3
        
        let cifilter4 = CIFilter(name: "CISepiaTone")
        cifilter4!.setDefaults()
        cifilter4!.setValue(originalImage, forKey: kCIInputImageKey)
        let outputImage4 = cifilter4!.outputImage
        let newImage4 = UIImage(CIImage: outputImage4!)
        filter4.image = newImage4
        
        let cifilter5 = CIFilter(name: "CIPhotoEffectTransfer")
        cifilter5!.setDefaults()
        cifilter5!.setValue(originalImage, forKey: kCIInputImageKey)
        let outputImage5 = cifilter5!.outputImage
        let newImage5 = UIImage(CIImage: outputImage5!)
        filter5.image = newImage5
        
        let cifilter6 = CIFilter(name: "CIPhotoEffectProcess")
        cifilter6!.setDefaults()
        cifilter6!.setValue(originalImage, forKey: kCIInputImageKey)
        let outputImage6 = cifilter6!.outputImage
        let newImage6 = UIImage(CIImage: outputImage6!)
        filter6.image = newImage6
        
        let cifilter7 = CIFilter(name: "CIPhotoEffectChrome")
        cifilter7!.setDefaults()
        cifilter7!.setValue(originalImage, forKey: kCIInputImageKey)
        let outputImage7 = cifilter7!.outputImage
        let newImage7 = UIImage(CIImage: outputImage7!)
        filter7.image = newImage7
        
        let cifilter8 = CIFilter(name: "CIVignetteEffect")
        cifilter8!.setDefaults()
        cifilter8!.setValue(originalImage, forKey: kCIInputImageKey)
        let outputImage8 = cifilter8!.outputImage
        let newImage8 = UIImage(CIImage: outputImage8!)
        filter8.image = newImage8
        
    }
        
        
    @IBAction func onTap1(sender: AnyObject) {
        let cgimg = selectedImage.image?.CGImage
        let coreImage = CIImage(CGImage: cgimg!)
        let noir = CIFilter(name:"CIPhotoEffectMono")
        noir!.setValue(coreImage, forKey:kCIInputImageKey)
        if let output = noir!.valueForKey(kCIOutputImageKey) as? CIImage {
            
            let context = CIContext(options: nil)
            let filteredImg = context.createCGImage(output, fromRect: output.extent)
            //convert back to UI Image
            let filteredImage = UIImage(CGImage: filteredImg)
            selectedImage?.image = filteredImage
            
        }

    }
    
    @IBAction func onTap2(sender: AnyObject) {
        let cgimg = selectedImage.image?.CGImage
        let coreImage = CIImage(CGImage: cgimg!)
        let noir = CIFilter(name:"CIPhotoEffectInstant")
        noir!.setValue(coreImage, forKey:kCIInputImageKey)
        if let output = noir!.valueForKey(kCIOutputImageKey) as? CIImage {
            
            let context = CIContext(options: nil)
            let filteredImg = context.createCGImage(output, fromRect: output.extent)
            //convert back to UI Image
            let filteredImage = UIImage(CGImage: filteredImg)
            selectedImage?.image = filteredImage
            
        }
        

    }
    
    @IBAction func onTap3(sender: AnyObject) {
        let cgimg = selectedImage.image?.CGImage
        let coreImage = CIImage(CGImage: cgimg!)
        let noir = CIFilter(name:"CIPhotoEffectTonal")
        noir!.setValue(coreImage, forKey:kCIInputImageKey)
        if let output = noir!.valueForKey(kCIOutputImageKey) as? CIImage {
            
            let context = CIContext(options: nil)
            let filteredImg = context.createCGImage(output, fromRect: output.extent)
            //convert back to UI Image
            let filteredImage = UIImage(CGImage: filteredImg)
            selectedImage?.image = filteredImage
            
        }
        
    }
    
    @IBAction func onTap4(sender: AnyObject) {
        let cgimg = selectedImage.image?.CGImage
        let coreImage = CIImage(CGImage: cgimg!)
        let noir = CIFilter(name:"CISepiaTone")
        noir!.setValue(coreImage, forKey:kCIInputImageKey)
        if let output = noir!.valueForKey(kCIOutputImageKey) as? CIImage {
            
            let context = CIContext(options: nil)
            let filteredImg = context.createCGImage(output, fromRect: output.extent)
            //convert back to UI Image
            let filteredImage = UIImage(CGImage: filteredImg)
            selectedImage?.image = filteredImage
            
        }

    }

    @IBAction func onTap5(sender: AnyObject) {
        let cgimg = selectedImage.image?.CGImage
        let coreImage = CIImage(CGImage: cgimg!)
        let noir = CIFilter(name:"CIPhotoEffectTransfer")
        noir!.setValue(coreImage, forKey:kCIInputImageKey)
        if let output = noir!.valueForKey(kCIOutputImageKey) as? CIImage {
            
            let context = CIContext(options: nil)
            let filteredImg = context.createCGImage(output, fromRect: output.extent)
            //convert back to UI Image
            let filteredImage = UIImage(CGImage: filteredImg)
            selectedImage?.image = filteredImage
            
        }
        
    }

    @IBAction func onTap6(sender: AnyObject) {
        let cgimg = selectedImage.image?.CGImage
        let coreImage = CIImage(CGImage: cgimg!)
        let noir = CIFilter(name:"CIPhotoEffectProcess")
        noir!.setValue(coreImage, forKey:kCIInputImageKey)
        if let output = noir!.valueForKey(kCIOutputImageKey) as? CIImage {
            
            let context = CIContext(options: nil)
            let filteredImg = context.createCGImage(output, fromRect: output.extent)
            //convert back to UI Image
            let filteredImage = UIImage(CGImage: filteredImg)
            selectedImage?.image = filteredImage
            
        }

        
    }
    
    @IBAction func onTap7(sender: AnyObject) {
        let cgimg = selectedImage.image?.CGImage
        let coreImage = CIImage(CGImage: cgimg!)
        let noir = CIFilter(name:"CIPhotoEffectChrome")
        noir!.setValue(coreImage, forKey:kCIInputImageKey)
        if let output = noir!.valueForKey(kCIOutputImageKey) as? CIImage {
            
            let context = CIContext(options: nil)
            let filteredImg = context.createCGImage(output, fromRect: output.extent)
            //convert back to UI Image
            let filteredImage = UIImage(CGImage: filteredImg)
            selectedImage?.image = filteredImage
            
        }

        
    }
    
    @IBAction func onTap8(sender: AnyObject) {
        let cgimg = selectedImage.image?.CGImage
        let coreImage = CIImage(CGImage: cgimg!)
        let noir = CIFilter(name:"CIVignetteEffect")
        noir!.setValue(coreImage, forKey:kCIInputImageKey)
        if let output = noir!.valueForKey(kCIOutputImageKey) as? CIImage {
            
            let context = CIContext(options: nil)
            let filteredImg = context.createCGImage(output, fromRect: output.extent)
            //convert back to UI Image
            let filteredImage = UIImage(CGImage: filteredImg)
            selectedImage?.image = filteredImage
            
        }

    }
    
    
    
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
    }




