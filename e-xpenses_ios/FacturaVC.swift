//
//  FacturaVC.swift
//  e-xpenses_ios
//
//  Created by raul tadeo gonzale alvarez on 11/06/16.
//  Copyright © 2016 masnegocio. All rights reserved.
//

import UIKit

class FacturaVC: UIViewController,UITableViewDataSource {
    
    var IP_VALIDADOR_QA = "http://qa.pacmasnegocio.com:2376/facturas/validacion"
    var TOKEN_VALIDADOR_CFDI_QA = "eyAidHlwIjogIkpXVCIsICJhbGciOiAiSFMyNTYiIH0=.eyAic3ViIiA6ICJQQUNNTl9BUEkiLCAiaWF0IiA6ICIyMDE1MDIyMzA5MDAwMCIsICJrZXkiIDogInhNN3pjQ3kyTDg3RVpBQzNNcEhTVUhwMGtWOThBWGxoS0IyMjI4QUkwMDA9IiB9.9AfJIOslGUKc6OtTbcuZNGITp3AgwznSPBqLsCXa9wk="

    
    var nodos = [NodoXml]()
    var facturaCompleta = ""
    
    var datos = [Factura]()
    
    @IBOutlet weak var rfcEmisor: UILabel!
    @IBOutlet weak var razonEmisor: UILabel!
 
    @IBOutlet weak var rfcReceptor: UILabel!
    @IBOutlet weak var razonReceptor: UILabel!
    
    @IBOutlet weak var tabla: UITableView!
    //boton regresar
    // self.dismissViewControllerAnimated(true, completion: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        tabla.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        validarCfdi(facturaCompleta)
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
                       
                        
                        self.addValues(jsonResult as! NSDictionary)
                        
                    }else{
                        self.showMessage(jsonResult)
                    }
                    
                }else{
                    self.showError()
                }
                
            }
        }
        
        task.resume()
        
    }

    func addValues(json:NSDictionary){
        
        
        let jsonEmisor = json["emisor"]
        let jsonReceptor = json["receptor"]
        let jsonFactura = json["factura"]
        dispatch_async(dispatch_get_main_queue(), {
            
            self.rfcEmisor.text = jsonEmisor?.valueForKey("rfc") as? String
            self.razonEmisor.text = jsonEmisor?.valueForKey("razonSocial") as? String
            self.rfcReceptor.text = jsonReceptor?.valueForKey("rfc") as? String
            self.razonReceptor.text = jsonReceptor?.valueForKey("razonSocial") as? String
            
            
            
            for(k,v)in jsonFactura as! NSDictionary{
                if let tituloAux = k as? String,let detalleAux = v as? String{
                    let fac = Factura(titulo:tituloAux,detalle:detalleAux)
                    self.datos.append(fac)
                }
                
            }
            
            if(self.datos.count>0){
                self.tabla.reloadData()
            }
            
            
            
            
            
        })
        

    }
    
    func showMessage(json:AnyObject){
        dispatch_async(dispatch_get_main_queue(), {
            
           self.showAlert("Alerta",mensaje: "Factura con errores: \(json)")
        })

    }
    
    func showError(){
        dispatch_async(dispatch_get_main_queue(), {
            self.showAlert("Alerta",mensaje: "Factura incorrecta")
        })

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
    
    /*override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }*/



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: -UITableDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("FacturaCell", forIndexPath: indexPath)
            as! FacturaCell
        
        cell.titulo.text = datos[indexPath.row].titulo
        cell.detalle.text = datos[indexPath.row].detalle
        
        return cell

    }


}
