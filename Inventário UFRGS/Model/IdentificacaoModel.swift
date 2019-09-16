//
//  IdentificacaoModel.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 04/10/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import SwiftyJSON

class IdentificacaoModel: NSObject {
    var nome: String = ""
    var identificacao: String = ""
    
    override init() {
        self.nome = "null"
        self.identificacao = "null"
    }
    
    init(withJson json: JSON) {
        self.nome = String(describing: json["NomePessoa"])
        self.identificacao = String(describing: json["CodPessoa"])
    }
}
