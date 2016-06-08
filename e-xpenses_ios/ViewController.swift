//
//  ViewController.swift
//  e-xpenses_ios
//
//  Created by raul tadeo gonzale alvarez on 29/04/16.
//  Copyright © 2016 masnegocio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var olvidasteContrasenia: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        return UIInterfaceOrientationMask.Landscape
    }


}

