//
//  UIAlertMultiLine.swift
//  Inventário UFRGS
//
//  Created by Augusto on 04/09/2018.
//  Copyright © 2018 CPD UFRGS. All rights reserved.
//

import UIKit

class UIAlertMultiLine: UIAlertController {
    static func configure() {
        UILabel.appearance(whenContainedInInstancesOf:
            [UIAlertMultiLine.self]).numberOfLines = 0
        UILabel.appearance(whenContainedInInstancesOf:
            [UIAlertMultiLine.self]).lineBreakMode = .byWordWrapping
    }
}
