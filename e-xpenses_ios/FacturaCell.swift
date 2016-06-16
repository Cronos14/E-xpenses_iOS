//
//  FacturaCell.swift
//  e-xpenses_ios
//
//  Created by raul tadeo gonzale alvarez on 13/06/16.
//  Copyright © 2016 masnegocio. All rights reserved.
//

import UIKit

class FacturaCell: UITableViewCell {

    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var detalle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
