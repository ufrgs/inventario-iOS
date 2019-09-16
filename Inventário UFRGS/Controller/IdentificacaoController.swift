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
    @IBOutlet weak var logoutButton: UIButton!
    
    var ident = IdentificacaoModel()
    
    let apiCalls = API()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Identificação"
        
        Helper.configureButton(button: logoutButton)
        
        self.ident = generalIdent
        self.nomeLabel.text = self.ident.nome
        self.identificacaoLabel.text = self.ident.identificacao
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
        UserDef.deleteToken()
        self.dismiss(animated: true, completion: nil)
        
    }
}
