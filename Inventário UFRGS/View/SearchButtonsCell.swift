//
//  SearchButtonsCell.swift
//  Inventário UFRGS
//
//  Created by Augusto on 06/09/2018.
//  Copyright © 2018 CPD UFRGS. All rights reserved.
//

import UIKit

class SearchButtonsCell: UITableViewCell {
    
    let CORNER_RADIUS: CGFloat = 12.0
    
    @IBOutlet weak var barCodeButton: UIButton!
    @IBOutlet weak var manualTypeButton: UIButton!
    @IBOutlet weak var plaquelessButton: UIButton!

    func configureButtons() {
        barCodeButton.layer.cornerRadius = CORNER_RADIUS
        manualTypeButton.layer.cornerRadius = CORNER_RADIUS
        plaquelessButton.layer.cornerRadius = CORNER_RADIUS
    }
    
}
