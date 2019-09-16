//
//  PendenciaModel.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 03/10/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation

class PendenciaModel: NSObject {
    
    var nome: String = ""
    var tipo: String = ""
    var seq: String = ""
    
    override init() {}
    
    init(nome: String, tipo: String, seq: String) {
        self.nome = nome
        self.tipo = tipo
        self.seq = seq
    }
}
