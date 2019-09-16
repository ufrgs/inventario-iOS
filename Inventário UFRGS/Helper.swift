//
//  Helper
//  Inventário UFRGS
//
//  Created by Augusto on 21/08/2018.
//  Copyright © 2018 CPD UFRGS. All rights reserved.
//

import SwiftOverlays
import Foundation
import UIKit

class Helper {
    
    static func showSimpleAlert(controller: UIViewController, title: String, message: String, actionTitle: String, action: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: action))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertTwoOptions(controller: UIViewController, title: String, message: String, negativeTitle: String, negativeAction: ((UIAlertAction) -> Void)?, positiveTitle: String, positiveAction: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: negativeTitle, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: positiveTitle, style: .default, handler: positiveAction))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func createInputAlert(title: String, message: String, placeholder: String, negativeTitle: String, positiveTitle: String, positiveCallback: @escaping (UIAlertController) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.textFields![0].text = placeholder
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            positiveCallback(alert)
        })
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        return alert
    }
    
    static func createInputAlert(title: String, message: String, textFieldConfiguration: ((UITextField) -> Void)?, placeholder: String, negativeTitle: String, positiveTitle: String, positiveCallback: @escaping (UIAlertController) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: textFieldConfiguration)
        alert.textFields![0].text = placeholder
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            positiveCallback(alert)
        })
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        return alert
    }
    
    static func configureButton(button: UIButton) {
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    static func showLoading(view: UIView) {
        if let superview = view.superview {
            SwiftOverlays.showCenteredWaitOverlay(superview)
        }
    }
    
    static func removeLoading(view: UIView) {
        if let superview = view.superview {
            SwiftOverlays.removeAllOverlaysFromView(superview)
        }
    }
}
