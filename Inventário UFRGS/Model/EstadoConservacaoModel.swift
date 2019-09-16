//
//  EstadoConservacaoModel.swift
//  Inventário UFRGS
//
//  Created by Augusto on 04/09/2018.
//  Copyright © 2018 CPD UFRGS. All rights reserved.
//

import Foundation

class EstadoConservacaoModel: NSObject {
    
    var tipoEstadoConservacao: String = ""
    var descricaoEstadoConservacao: String = ""
    var observacao: String = ""
    
    override init() {}
    
    init(tipo: String, descricao: String, obs: String) {
        self.tipoEstadoConservacao = tipo
        self.descricaoEstadoConservacao = descricao
        self.observacao = obs
    }
}
