//
//  Factura.swift
//  e-xpenses_ios
//
//  Created by raul tadeo gonzale alvarez on 13/06/16.
//  Copyright © 2016 masnegocio. All rights reserved.
//

import Foundation
struct Factura{
    var titulo:String
    var detalle:String
    
    init(titulo:String,detalle:String){
        self.titulo = titulo
        self.detalle = detalle
    }
}
