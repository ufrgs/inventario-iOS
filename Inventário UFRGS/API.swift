//
//  API.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 28/09/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class API: NSObject {
    
    let APIURL = ""
    var error_code = ""
    var code = ""
    
    // --------------------------------
    // PUBLIC METHODS
    // --------------------------------
    
    func getEspacosFisicos(predio: String, completionHandler: @escaping ([PredioModel], Error?) -> ()) {}
    func getInfoBem(nroPatrimonio: String, completionHandler: @escaping (BemModel, Error?) -> ()) {}
    func getPendencias(completionHandler: @escaping ([PendenciaModel], Error?) -> ()) {}
    func postColetaInventario(infoBem: BemModel, completionHandler: @escaping (String, Error?) -> ()) {}
    func getOrders(completionHandler: @escaping (Bool?, Error?) -> (), id: String, pass: String) {}
    func getPessoa(completionHandler: @escaping (IdentificacaoModel, Error?) -> ()) {}
    func postPendencia(seq: String, pend: String, completionHandler: @escaping (Bool?, Error?) -> ()) {}
    func getPessoaBasico(cartao: String, completionHandler: @escaping (IdentificacaoModel, Error?) -> ()) {}
    func getPessoasBasico(nome: String, completionHandler: @escaping ([IdentificacaoModel], Error?) -> ()) {}
    func getLocais(completionHandler: @escaping ([PredioModel], Error?) -> ()) {}
    func getPredios(completionHandler: @escaping ([PredioModel], Error?) -> ()) {}
    func getSituacoesBens(completionHandler: @escaping ([SituacaoModel], Error?) -> ()) {}
    func getEstadosConservacaoBens(completionHandler: @escaping ([EstadoConservacaoModel], Error?) -> ()) {}
    func getOrgaoDiretor(codOrgao: String, completionHandler: @escaping (IdentificacaoModel, Error?) -> ()) {}
    func getBemDescricoes(completionHandler: @escaping ([DescricaoBemModel], Error?) -> ()) {}
    
    // Attribute getters
    
    func getCode() -> String {
        return self.code
    }
    
    func getErrorCode() -> String {
        return self.error_code
    }
    
    // --------------------------------
    // AUXILIAR METHODS
    // --------------------------------
    
    func prepareURLParameter(text: String) -> String {
        var newText = text.folding(options: .diacriticInsensitive, locale: .current)
        newText = newText.replacingOccurrences(of: " ", with: "+")
        
        let charactersToRemove = ["/", "\\", ".", "{", "}", "\'", "?", "=", "<", ">", "%", "&", "¥", "£", "€", "•", "^", "|"]
        for char in charactersToRemove {
            newText = newText.replacingOccurrences(of: char, with: "")
        }
        
        return newText
    }
    
}
