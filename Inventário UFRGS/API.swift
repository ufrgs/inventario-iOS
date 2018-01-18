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

var error_code = ""
var code = ""
class API: NSObject {
    
    let APIURL = ""
    
    func getEspacosFisicos(predio: String, completionHandler: @escaping ([PredioModel], Error?) -> ()) {
        espacosFisicos("orders", predio: predio, completionHandler: completionHandler  )
    }
    func getInfoBem(nroPatrimonio: String, completionHandler: @escaping (BemModel, Error?) -> ()) {
        infoBem("orders", nroPatrimonio: nroPatrimonio, completionHandler: completionHandler  )
    }
    
    func getPendencias(completionHandler: @escaping ([PendenciaModel], Error?) -> ()) {
        pendencias("orders", completionHandler: completionHandler)
    }
    
    func postColetaInventario(infoBem: BemModel, completionHandler: @escaping (String, Error?) -> ()) {
        coletaInventario("orders", infoBem: infoBem, completionHandler: completionHandler)
    }
    
    func getOrders(completionHandler: @escaping (Bool?, Error?) -> (), id: String, pass: String) {
        makeCall("orders", completionHandler: completionHandler, id: id, pass: pass)
    }
    
    func getPessoa(completionHandler: @escaping (IdentificacaoModel, Error?) -> ()) {
        pessoa("orders", completionHandler: completionHandler)
    }
    
    func postPendencia(seq: String, pend: String, completionHandler: @escaping (Bool?, Error?) -> ()) {
        pendencia("orders", seq: seq, pend: pend, completionHandler: completionHandler)
    }
    
    func getPessoaBasico(cartao: String, completionHandler: @escaping (IdentificacaoModel, Error?) -> ()) {
        pessoaBasico("orders", cartao: cartao, completionHandler: completionHandler  )
    }
    
    // #################################################################################
    
    func espacosFisicos(_ section: String, predio: String, completionHandler: @escaping ([PredioModel], Error?) -> ()) {
        var espacosList = [PredioModel]()
        completionHandler(espacosList, nil)
    }
    
    func infoBem(_ section: String, nroPatrimonio: String, completionHandler: @escaping (BemModel, Error?) -> ()) {
        let bemInfo = BemModel()
        completionHandler(bemInfo, nil)
    }
    
    func pendencias(_ section: String, completionHandler: @escaping ([PendenciaModel], Error?) -> ()) {
        var pendencias = [PendenciaModel]()
        completionHandler(pendencias, nil)
    }
    
    func coletaInventario(_ section: String, infoBem: BemModel, completionHandler: @escaping (String, Error?) -> ()) {
        var jsonString = ""
        completionHandler(jsonString, nil)
    }
    
    func makeCall(_ section: String, completionHandler: @escaping (Bool, Error?) -> (), id: String, pass: String) {
        var result: Bool = false
        completionHandler(result, nil)
    }
    
    
    func pessoa(_ section: String, completionHandler: @escaping (IdentificacaoModel, Error?) -> ()) {
        let ident = IdentificacaoModel()
        completionHandler(ident, nil)
    }
    
    func pendencia(_ section: String, seq: String, pend: String, completionHandler: @escaping (Bool, Error?) -> ()) {
        var result: Bool = false
        completionHandler(result, nil)
    }
    
    func pessoaBasico(_ section: String, cartao: String, completionHandler: @escaping (IdentificacaoModel, Error?) -> ()) {
        let ident = IdentificacaoModel()
        completionHandler(ident, nil)
    }

}



























