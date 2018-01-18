//
//  ViewController.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 11/09/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit
import BarcodeScanner
import AVFoundation
import SwiftOverlays

class ViewController: UIViewController {
    
    let apiCalls = API()
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Inventário UFRGS"
        
        id.text = ""
        pass.text = ""
        
        loginButton.layer.cornerRadius = 20
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDef.getToken() != "nil" {
            performSegue(withIdentifier: "loginSucc", sender: self)
        }
    }
    
    override func  didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginAction(_ sender: Any) {
        if id.text != "" && pass.text != "" {
            
            self.showWaitOverlay()
            self.apiCalls.getOrders(completionHandler: { (responseObject, error) in
                if responseObject == true{
                    self.removeAllOverlays()
                    self.performSegue(withIdentifier: "loginSucc", sender: Any?.self)
                }
                
                else if error_code == "401" {
                    self.removeAllOverlays()
                    let alert = UIAlertController(title: "Permissão negada!", message: "Você não tem permissão para fazer login. Uso exclusivo para servidores da universidade.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                    
                else {
                    self.removeAllOverlays()
                    let alert = UIAlertController(title: "Atenção!", message: "Identificação e/ou senha incorretos. Corrija suas informações e tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }, id: id.text!, pass: pass.text!)
            
        }
    }
}


