//
//  AnticiposCell.swift
//  e-xpenses_ios
//
//  Created by raul tadeo gonzale alvarez on 29/04/16.
//  Copyright © 2016 masnegocio. All rights reserved.
//

import UIKit

class AnticiposCell: UITableViewCell {

    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var monto: UILabel!
    @IBOutlet weak var moneda: UILabel!
    @IBOutlet weak var estatus: UILabel!
    @IBOutlet weak var hora: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
