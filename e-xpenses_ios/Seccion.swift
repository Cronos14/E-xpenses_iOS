//
//  Seccion.swift
//  e-xpenses_ios
//
//  Created by raul tadeo gonzale alvarez on 02/05/16.
//  Copyright © 2016 masnegocio. All rights reserved.
//

import Foundation

struct Seccion {
    var nombre : String
    var opciones : [String]
    
    init(nombre:String, opciones:[String]){
        self.nombre = nombre
        self .opciones = opciones
    }
}
