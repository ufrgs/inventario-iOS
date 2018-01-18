//
//  BemModel.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 29/09/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
class BemModel: NSObject {
    
    /* EDITAVEIS */

    var nome: String = ""
    var marca: String = ""
    var modelo: String = ""
    var serie: String = ""
    var caracteristicas: String = ""
    var tipoEstadoConvervcao: String = ""
    var descricaoEstadoConservacao: String = ""
    var obsSituacao: String = ""
    
    /* NAO EDITAVEIS */
    
    var nrPatrimonio: String = ""
    var nomeResponsavel: String = ""
    var nomeCoResponsavel: String = ""
    var codPessoaCoResponsavel: String = ""
    var tipoSituacao: String = ""
    var descricaoSituacao: String = ""
    var codPredio: String = ""
    var codOrgao: String = ""
    var codEspacoFisico: String = ""
    var codPessoaColeta: String = ""
    var codPessoaResponsavel: String = ""
    var dataHoraColeta: String = ""
    
}
