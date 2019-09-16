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
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDef.getToken() != "nil" {
            // se já estiver logado, pega na API os dados da pessoa e vai pra próxima tela
            self.getGeneralIdent {
                self.performSegue(withIdentifier: "loginSucc", sender: Any?.self)
            }
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
//        if !self.fieldsAreValid() {
//            return
//        }
        
        self.showWaitOverlay()
        
        self.apiCalls.getOrders(completionHandler: { (responseObject, error) in
            
            self.removeAllOverlays()

            if responseObject == true {
                // se tudo der certo, pega na API os dados da pessoa e vai pra próxima tela
                self.getGeneralIdent {
                    self.performSegue(withIdentifier: "loginSucc", sender: Any?.self)
                }
            }
            
            else if self.apiCalls.getErrorCode() == "401" {
                Helper.showSimpleAlert(controller: self,
                                 title: "Permissão negada!",
                                 message: "Você não tem permissão para fazer login. Uso exclusivo para servidores da universidade.",
                                 actionTitle: "Ok",
                                 action: nil)
            }
                
            else {
                Helper.showSimpleAlert(controller: self,
                                 title: "Atenção!",
                                 message: "Identificação e/ou senha incorretos. Corrija suas informações e tente novamente.",
                                 actionTitle: "Ok",
                                 action: nil)
            }
        }, id: id.text!, pass: pass.text!)
    }
    
    func fieldsAreValid() -> Bool {
        return id.text != "" && pass.text != ""
    }
    
    func getGeneralIdent(completion: @escaping () -> ()) {
        self.showWaitOverlay()
        
        apiCalls.getPessoa { (responseObj, error) in
            self.removeAllOverlays()
            
            generalIdent = responseObj
            
            completion()
        }
    }
}

