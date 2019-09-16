//
//  DescricaoBemModel.swift
//  Inventário UFRGS
//
//  Created by Augusto on 06/09/2018.
//  Copyright © 2018 CPD UFRGS. All rights reserved.
//

import Foundation

class DescricaoBemModel: NSObject {
    
    var codigoDescricao: String = ""
    var descricaoPadronizada: String = ""
    
    override init() {}
    
    init(codigo: String, descricao: String) {
        self.codigoDescricao = codigo
        self.descricaoPadronizada = descricao
    }
}
