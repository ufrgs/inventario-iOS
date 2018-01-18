//
//  IdentificacaoController.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 03/10/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit
import SwiftOverlays

var generalIdent = IdentificacaoModel()
var novaConsulta = -1

class IdentificacaoController: UIViewController {
    
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var identificacaoLabel: UILabel!
    @IBOutlet weak var novaConsultaButt: UIButton!
    @IBOutlet weak var novoInventButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var ident = IdentificacaoModel()
    
    let apiCalls = API()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        novaConsultaButt = setButton(button: novaConsultaButt)
        novoInventButton = setButton(button: novoInventButton)
        logoutButton = setButton(button: logoutButton)
        
        self.title = "Identificação"
        self.showWaitOverlay()
        apiCalls.getPessoa { (responseObj, error) in
            self.removeAllOverlays()
            self.ident = responseObj
            generalIdent = responseObj
            self.nomeLabel.text = responseObj.nome
            self.identificacaoLabel.text = responseObj.identificacao
        }
        
        self.novaConsultaButt.isHidden = true
        
    }
    
    func setButton(button: UIButton) -> UIButton{
        
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }
    
    
    @IBAction func logoutAction(_ sender: Any) {
        
        UserDef.deleteToken()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if novaConsulta != -1 {
            self.novaConsultaButt.isHidden = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
