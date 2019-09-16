//
//  PendenciaModel.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 03/10/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation

class SituacaoModel: NSObject {
    
    var tipoSituacao: String = ""
    var descricaoSituacao: String = ""
    
    override init() {}
    
    init(tipo: String, descricao: String) {
        self.tipoSituacao = tipo
        self.descricaoSituacao = descricao
    }
}
