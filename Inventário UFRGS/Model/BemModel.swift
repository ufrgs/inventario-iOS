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
    var codDescricao: String = ""
    var marca: String = ""
    var modelo: String = ""
    var serie: String = ""
    var caracteristicas: String = ""
    var tipoEstadoConvervcao: String = ""
    var descricaoEstadoConservacao: String = ""
    var obsSituacao: String = ""
    var indicadorOcioso: String = "N"
    
    /* NAO EDITAVEIS */
    var nrPatrimonio: String = ""
    var nomeResponsavel: String = ""
    var nomeCoResponsavel: String = ""
    var codPessoaCoResponsavel: String = ""
    var nomeOrgaoResponsavel: String = ""
    var tipoSituacao: String = ""
    var descricaoSituacao: String = ""
    var codPredio: String = ""
    var codOrgao: String = ""
    var codEspacoFisico: String = ""
    var codPessoaColeta: String = ""
    var codPessoaResponsavel: String = ""
    var dataHoraColeta: String = ""
    
    override init() {}
    
    func clearEditables() {
        self.nome = "null"
        self.marca = "null"
        self.modelo = "null"
        self.serie = "null"
        self.caracteristicas = "null"
        self.tipoEstadoConvervcao = "null"
        self.descricaoEstadoConservacao = "null"
        self.obsSituacao = "null"
        
        self.tipoSituacao = "null"
        self.descricaoSituacao = "null"
        self.nomeCoResponsavel = "null"
    }
    
    func setBasicFields() {
        self.codOrgao = orgaoIndex.codPredio
        self.codPredio = predioIndex.codPredio
        self.codEspacoFisico = espacoFisicoIndex.codPredio
        self.codPessoaColeta = generalIdent.identificacao
        self.indicadorOcioso = "N"
    }
    
    func setColetaDate() {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dta = formatter.string(from: date)
        
        self.dataHoraColeta = dta
    }
}
