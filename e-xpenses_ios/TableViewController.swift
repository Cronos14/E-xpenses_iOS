//
//  TableViewController.swift
//  e-xpenses_ios
//
//  Created by raul tadeo gonzale alvarez on 29/04/16.
//  Copyright © 2016 masnegocio. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var nombres = ["Abril","Comprobacion Agosto"]
    var descripciones = ["DireccionComercial","DireccionComercial"]
    var fechas = ["2015/04/07","2015/04/07"]
    var montos = ["3210.0","2580.0"]
    var monedas = ["MXN","MXN"]
    var estatus = ["Autorizado","Autorizado"]
    var horas = ["07:48","02:25"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nombres.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        as! AnticiposCell

        cell.nombre.text = nombres[indexPath.row]
        cell.descripcion.text = descripciones[indexPath.row]
        cell.fecha.text = fechas[indexPath.row]
        cell.monto.text = montos[indexPath.row]
        cell.moneda.text = monedas[indexPath.row]
        cell.estatus.text = estatus[indexPath.row]
        cell.estatus.textColor = UIColor.greenColor()
        cell.hora.text = horas[indexPath.row]
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
   

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        let tabController = segue.destinationViewController as! UITabBarController
        let destination = tabController.viewControllers![0] as! AnticipoDetalleVC
        
        let anticipo = Anticipo()
        anticipo.monto = Double(montos[tableView.indexPathForSelectedRow!.row])
        anticipo.estatus = estatus[tableView.indexPathForSelectedRow!.row]
        anticipo.fecha = fechas[tableView.indexPathForSelectedRow!.row]
        anticipo.hora = horas[tableView.indexPathForSelectedRow!.row]
        destination.anticipo = anticipo
    }
 

}
