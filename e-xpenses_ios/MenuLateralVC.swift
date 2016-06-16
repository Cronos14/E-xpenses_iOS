//
//  MenuLateralVC.swift
//  e-xpenses_ios
//
//  Created by raul tadeo gonzale alvarez on 01/05/16.
//  Copyright © 2016 masnegocio. All rights reserved.
//

import UIKit

class MenuLateralVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var header: UIView!
    var secciones:[Seccion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let azulDark = UIColor.init(red: 20/255, green: 77/255, blue: 104/255, alpha: 1)
        let azulMedio = UIColor.init(red: 39/255, green: 101/255, blue: 129/255, alpha: 1)
        let azulClaro = UIColor.init(red: 109/255, green: 173/255, blue: 202/255, alpha: 1)

        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = header.bounds
        gradient.colors = [azulDark.CGColor,azulMedio.CGColor, azulClaro.CGColor]
        //gradient.colors = [UIColor.redColor().CGColor, UIColor.blackColor().CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        gradient.startPoint = CGPointMake(0,0);
        gradient.endPoint = CGPointMake(1, 1);
        
        
        let opciones1 = ["Anticipos","Revisar Tramites"]
        let opciones2 = ["Cerrar Sesion"]
        
        secciones.append(Seccion(nombre:"Opciones",opciones:opciones1))
        secciones.append(Seccion(nombre:"Usuario",opciones:opciones2))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones[section].opciones.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        
        cell.textLabel?.text = secciones[indexPath.section].opciones[indexPath.row]
        return cell

    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return secciones.count
    }

    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return secciones[section].nombre
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0{
            
            
            let refreshAlert = UIAlertController(title: "Alerta", message: "¿Seguro que desea cerrar sesion?", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                
                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                
                
                
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "user")
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "pass")
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("Root") as! ViewController
                self.presentViewController(nextViewController, animated:true, completion:nil)
                
                
                
            }))

            
            //mostrar alerta
            presentViewController(refreshAlert, animated: true, completion: nil)
            
            
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
