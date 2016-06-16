//
//  ViewController.swift
//  e-xpenses_ios
//
//  Created by raul tadeo gonzale alvarez on 29/04/16.
//  Copyright © 2016 masnegocio. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var olvidasteContrasenia: UILabel!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        
        initLogin(usuario.text!,password: password.text!)
        
    }
    
    func initLogin(usuario:String, password:String){
        if let empresaBase64 = NSUserDefaults.standardUserDefaults().objectForKey("empresa") as? String{
            
            if let decodedData:NSData = NSData(base64EncodedString: empresaBase64, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters){
                
                if let empresaText = NSString(data:decodedData, encoding:NSUTF8StringEncoding) as? String{
                    
                    
                    print("empresaText \(empresaText)")
                    let apiLoginString = NSString(format: "%@:%@", usuario, password)
                    let apiLoginData = apiLoginString.dataUsingEncoding(NSUTF8StringEncoding)!
                    let base64ApiLoginString = apiLoginData.base64EncodedStringWithOptions([])
                    
                    NSUserDefaults.standardUserDefaults().registerDefaults(["UserAgent": "Custom-Agent"])
                    
                    let url = NSURL(string:"http://192.168.1.64:8080/e-xpenses_servicios/api/seguridad/login")
                    
                    let request = NSMutableURLRequest(URL:url!)
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue(empresaText, forHTTPHeaderField: "Client")
                    request.setValue(base64ApiLoginString, forHTTPHeaderField: "Authorization")
                    request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.1 Safari/537.36", forHTTPHeaderField: "User-Agent")
                    request.HTTPMethod = "POST"
                    
                    let loading = UIActivityIndicatorView()
                    loading.center = self.view.center
                    loading.hidesWhenStopped = true
                    loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                    loading.startAnimating()
                    
                    self.view.addSubview(loading)
                    
                    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                    
                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request){(data,response,error)->Void in
                        if error != nil{
                            print("error: \(error)")
                            dispatch_async(dispatch_get_main_queue()) {
                                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                                loading.stopAnimating()
                                
                                self.showAlert("Alerta", mensaje: "Error con la conexion al servidor")
                                
                            }
                           
                        }else{
                            dispatch_async(dispatch_get_main_queue()) {
                                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                                loading.stopAnimating()

                            }
                           
                            if let jsonResult = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers){
                                print("JSON response: \(jsonResult)")
                                let estatus = jsonResult["estatus"] as? Int
                                
                                if(estatus==200){
                                    
                                    dispatch_async(dispatch_get_main_queue()) {
                                        NSUserDefaults.standardUserDefaults().setObject(usuario, forKey: "user")
                                        NSUserDefaults.standardUserDefaults().setObject(password, forKey: "pass")
                                        
                                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                        
                                        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("main") as! SWRevealViewController
                                        self.presentViewController(nextViewController, animated:true, completion:nil)
                                    }
                                    
                                    
                                    
                                }else{
                                    dispatch_async(dispatch_get_main_queue()) {

                                    self.showAlert("alerta",mensaje:"Error al iniciar sesion")
                                    }
                                }
                                
                            }else{
                                print("JSON response: es nil")
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.showAlert("alerta",mensaje:"Error al iniciar sesion")

                                }
                                
                            }
                            
                            /* Para hacer algo con interfaz grafica
                             dispatch_async(dispatch_get_main_queue()) {
                             
                             }*/
                        }
                    }
                    
                    task.resume()
                    
                    
                }
            }
            
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(animated: Bool) {
       
        
        if let user = NSUserDefaults.standardUserDefaults().objectForKey("user") as? String{
            if let pass = NSUserDefaults.standardUserDefaults().objectForKey("pass") as? String{
                initLogin(user,password: pass)
            }
        }

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prueba(dato:String?){
    
        olvidasteContrasenia.text = dato!
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    func showAlert(titulo:String, mensaje:String){
    
        let refreshAlert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            
            
        }))
        
        //mostrar alerta
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }

}

