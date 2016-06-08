//
//  FacturaViewController.swift
//  e-xpenses_ios
//
//  Created by raul tadeo gonzale alvarez on 07/06/16.
//  Copyright © 2016 masnegocio. All rights reserved.
//

import UIKit

class FacturaViewController: UIViewController {
    
    @IBOutlet weak var emisor: UILabel!
    @IBOutlet weak var receptor: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var uuid: UILabel!
    @IBOutlet weak var content: UITextView!
    
    var nodos = [NodoXml]()
    
    @IBAction func regresar(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
      override func viewDidLoad() {
        super.viewDidLoad()
        
                        
    }
    override func viewDidAppear(animated: Bool) {
        
        let refreshAlert = UIAlertController(title: "Mensaje", message: "nodos: \(printNodos())", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        //mostrar alerta
        //presentViewController(refreshAlert, animated: true, completion: nil)
        
        
        emisor.text = findNodo("cfdi:Emisor")?.atributos["nombre"]
        receptor.text = findNodo("cfdi:Receptor")?.atributos["nombre"]
        total.text = findNodo("cfdi:Comprobante")?.atributos["total"]
        uuid.text = findNodo("tfd:TimbreFiscalDigital")?.atributos["UUID"]
        content.text = printNodos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
}

