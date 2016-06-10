//
//  FacturaViewController.swift
//  e-xpenses_ios
//
//  Created by raul tadeo gonzale alvarez on 07/06/16.
//  Copyright © 2016 masnegocio. All rights reserved.
//

import UIKit

class FacturaViewController: UIViewController {
    
    var IP_VALIDADOR_QA = "http://qa.pacmasnegocio.com:2376/facturas/validacion"
    var TOKEN_VALIDADOR_CFDI_QA = "eyAidHlwIjogIkpXVCIsICJhbGciOiAiSFMyNTYiIH0=.eyAic3ViIiA6ICJQQUNNTl9BUEkiLCAiaWF0IiA6ICIyMDE1MDIyMzA5MDAwMCIsICJrZXkiIDogInhNN3pjQ3kyTDg3RVpBQzNNcEhTVUhwMGtWOThBWGxoS0IyMjI4QUkwMDA9IiB9.9AfJIOslGUKc6OtTbcuZNGITp3AgwznSPBqLsCXa9wk="
    
    @IBOutlet weak var emisor: UILabel!
    @IBOutlet weak var receptor: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var uuid: UILabel!
    @IBOutlet weak var content: UITextView!
    
    var nodos = [NodoXml]()
    var facturaCompleta = ""
    
    @IBAction func regresar(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
      override func viewDidLoad() {
        super.viewDidLoad()
        
                        
    }
    override func viewDidAppear(animated: Bool) {
        validarCfdi(facturaCompleta)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validarCfdi(factura:NSString){
        
        let facturaUtf8 = factura.dataUsingEncoding(NSUTF8StringEncoding)!
        let facturaBase64 = facturaUtf8.base64EncodedStringWithOptions([])
        
        NSUserDefaults.standardUserDefaults().registerDefaults(["UserAgent": "Custom-Agent"])
        
        
       
        let url = NSURL(string:IP_VALIDADOR_QA)
        
        let request = NSMutableURLRequest(URL:url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(TOKEN_VALIDADOR_CFDI_QA, forHTTPHeaderField: "Token")
        request.HTTPMethod = "POST"
        
        //enviar objeto JSON como diccionario
        let dictionary = ["contenidoBase64": facturaBase64]
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(dictionary, options: [])

    
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){(data,response,error)->Void in
            if error != nil{
                print("error: \(error)")
            }else{
                if let jsonResult = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers){
                    print("JSON response: \(jsonResult)")
                    
                    if let respuesta = jsonResult["respuesta"] as? Int where respuesta == 1{
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self.emisor.text = self.findNodo("cfdi:Emisor")?.atributos["nombre"]
                            self.receptor.text = self.findNodo("cfdi:Receptor")?.atributos["nombre"]
                            self.total.text = self.findNodo("cfdi:Comprobante")?.atributos["total"]
                            self.uuid.text = self.findNodo("tfd:TimbreFiscalDigital")?.atributos["UUID"]
                            self.content.text = self.printNodos()

                        })
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), {

                            self.showAlert("Alerta",mensaje: "Factura con errores: \(jsonResult)")
                        })
                    }
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showAlert("Alerta",mensaje: "Factura incorrecta")
                    })
                }
                
                /* Para hacer algo con interfaz grafica
                 dispatch_async(dispatch_get_main_queue()) {
                 
                 }*/
            }
        }
        
        task.resume()
        
    }
    
    func printNodos()->String?{
        
        var xmlContent = ""
        
        for nodo in nodos{
            print("nombreNodo: \(nodo.nombre)")
            xmlContent+=nodo.nombre+"\n"
            for(atributo,valor)in nodo.atributos{
                print("\(atributo):\(valor)")
                xmlContent+="\(atributo):\(valor)"+"\n"
                xmlContent+="---------------------------------------------------\n"
            }
            print("------------------------------------------------------------")
        }
        
        return xmlContent
        
    }
    
    func findNodo(nombreNodo:String)->NodoXml?{
        for nodo in nodos{
            if(nodo.nombre == nombreNodo){
                return nodo
            }
        }
        return nil
    }
    
    func showAlert(titulo:String,mensaje:String){
        let refreshAlert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Aceptar", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        /*refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))*/
        
        //mostrar alerta
        presentViewController(refreshAlert, animated: true, completion: nil)

    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
}

