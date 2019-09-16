//
//  PredioModel.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 27/09/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class PredioModel: NSObject {
    static let undefinedCode = ""
    static let undefinedName = "prédio não especificado"
    
    var codPredio: String = ""
    var nomePredio: String = ""
    var sugestaoPredio: String = ""
    var codSemantico: String = ""
    var indexPredio: Int = -1
    
    override init() {}
    
    init(withPredioJson json: JSON, index: Int) {
        self.codPredio = String(describing: json["CodPredio"])
        self.nomePredio = String(describing: json["NomePredio"])
        self.codSemantico = String(describing: json["CodSemantico"])
        self.indexPredio = index
        self.sugestaoPredio = self.codPredio + " - " + self.nomePredio + " - " + self.codSemantico
    }
    
    init(withOrgaoJson json: JSON, index: Int) {
        self.codPredio = String(describing: json["CodOrgao"])
        self.nomePredio = String(describing: json["NomeOrgao"])
        self.codSemantico = String(describing: json["SiglaOrgao"])
        self.indexPredio = index
        self.sugestaoPredio = self.codSemantico + " - " + self.nomePredio
    }
    
    init(withEspacoFisicoJson json: JSON, index: Int) {
        self.codPredio = String(describing: json["CodEspacoFisico"])
        self.nomePredio = String(describing: json["DenominacaoEspacoFisico"])
        self.codSemantico = String(describing: json["CodSemantico"])
        self.indexPredio = index
        self.sugestaoPredio = self.codSemantico + " - " + self.nomePredio
    }
    
    func setUndefinedLabels() {
        self.codPredio = PredioModel.undefinedCode
        self.nomePredio = PredioModel.undefinedName
    }
    
    func codeIsDefined() -> Bool {
        return self.codPredio != PredioModel.undefinedCode
    }
}
