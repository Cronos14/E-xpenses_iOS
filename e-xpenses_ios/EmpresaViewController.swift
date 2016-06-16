//
//  EmpresaViewController.swift
//  e-xpenses_ios
//
//  Created by raul tadeo gonzale alvarez on 15/06/16.
//  Copyright © 2016 masnegocio. All rights reserved.
//

import UIKit
import AVFoundation

class EmpresaViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    
    @IBAction func leerQr(sender: AnyObject) {
        initLectorQr()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func initLectorQr(){
        
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }

        
        view.backgroundColor = UIColor.blackColor()
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        
        
        
         self.captureSession.startRunning();
        
        
        
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("empresa") as? String{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("Root") as! ViewController
            self.presentViewController(nextViewController, animated:true, completion:nil)
        }else{
            let refreshAlert = UIAlertController(title: "Mensaje", message: "Coloque su Codigo QR proporcionado por Mas Negocio en el interior del rectangulo visor", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                
                self.initLectorQr()
                
            }))
            
            //mostrar alerta
            presentViewController(refreshAlert, animated: true, completion: nil)

        }
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue);
        }
        
         //dismissViewControllerAnimated(true, completion: nil)
    }
    
    func foundCode(code: String) {
        print(code)
        
        if let decodedData:NSData = NSData(base64EncodedString: code, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters){
        
        if let datastring = NSString(data:decodedData, encoding:NSUTF8StringEncoding){
            
            let qr = datastring.substringWithRange(NSRange(location: 0, length: 2))
            
            if(qr=="qr"){
                let empresa = datastring.substringWithRange(NSRange(location: 2, length: datastring.length-2))
                
                let dato = datastring as String
                
                print("codigo: \(dato)")
                print("empresa: \(empresa)")
                
                let facturaUtf8 = empresa.dataUsingEncoding(NSUTF8StringEncoding)!
                let empresaBase64 = facturaUtf8.base64EncodedStringWithOptions([])
                
                NSUserDefaults.standardUserDefaults().setObject(empresaBase64, forKey: "empresa")
                
               
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("Root") as! ViewController
                self.presentViewController(nextViewController, animated:true, completion:nil)

                
              
            }else{
                
                let refreshAlert = UIAlertController(title: "Mensaje", message: "Qr incorrecto, intentelo nuevamente", preferredStyle: UIAlertControllerStyle.Alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                    /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                     
                     let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("qr") as! EmpresaViewController
                     self.presentViewController(nextViewController, animated:true, completion:nil)*/
                    
                    self.initLectorQr()

                    
                }))
                
                //mostrar alerta
                presentViewController(refreshAlert, animated: true, completion: nil)

            
            }
        }
            
        }else{
            let refreshAlert = UIAlertController(title: "Mensaje", message: "Qr incorrecto, intentelo nuevamente", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                
                
                /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("qr") as! EmpresaViewController
                self.presentViewController(nextViewController, animated:true, completion:nil)*/
                
                self.initLectorQr()
                
            }))
            
            //mostrar alerta
            presentViewController(refreshAlert, animated: true, completion: nil)
            
            
        }
                
    }
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
   
    
}
