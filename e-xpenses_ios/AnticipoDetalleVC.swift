//
//  AnticipoDetalleVC.swift
//  e-xpenses_ios
//
//  Created by raul tadeo gonzale alvarez on 02/05/16.
//  Copyright © 2016 masnegocio. All rights reserved.
//

import UIKit

class AnticipoDetalleVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var labelHora: UILabel!
    internal var nombre : String?
    var anticipo:Anticipo?
    
    @IBOutlet weak var imagen: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let anti = anticipo, monto = anti.monto,
            fecha = anti.fecha, hora = anti.hora {
            labelName.text = String(monto)
            labelFecha.text = fecha
            labelHora.text = hora
        }
    }
    
    
    @IBAction func tomarFoto(sender: AnyObject) {
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            
            let imagePc = UIImagePickerController()
            imagePc.delegate = self
            imagePc.sourceType = UIImagePickerControllerSourceType.Camera
            imagePc.allowsEditing = false
            
            self.presentViewController(imagePc,animated:true,completion:nil)
            
            
        } else {
            
            print("no hay camara")
            
        }

    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("Foto elegida")
        
        //let base64 = convertImageToBase64(image)
        //print("base64: \(base64.characters.count)")
        
        //redimencionar imagen
        let imageNew = resizeImage(image,newWidth:200)
        let base64New = convertImageToBase64(imageNew)
        print("width \(image.size.width) height \(image.size.height)")
        print("widthNew \(imageNew.size.width) heightNew \(imageNew.size.height)")
        print("base64New: \(base64New.characters.count)")
        
        
        imagen.image = convertBase64ToImage(base64New)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func convertImageToBase64(image: UIImage) -> String {
        
        let imageData:NSData = UIImagePNGRepresentation(image)!
        let base64String = imageData.base64EncodedStringWithOptions([])//.Encoding64CharacterLineLength
        
        return base64String
        
    }
    
    func convertBase64ToImage(base64String: String) -> UIImage {
        
        let decodedData:NSData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
        
        //let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions(rawValue: 0))
        
        let decodedimage = UIImage(data: decodedData)
        
        return decodedimage!
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}
