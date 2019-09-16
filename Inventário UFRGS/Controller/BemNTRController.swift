//
//  BemNTRViewController.swift
//  Inventário UFRGS
//
//  Created by Augusto on 27/08/2018.
//  Copyright © 2018 CPD UFRGS. All rights reserved.
//

import UIKit
import SwiftOverlays

class BemNTRController: BemInfoController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        self.title = "Bem NTR"
        self.grayed = [true, false, false, false, false, false, false, false, false, false, false, false]
        
        // pega o nome do diretor do Órgão selecionado e o coloca como responsável do Bem
        apiCalls.getOrgaoDiretor(codOrgao: orgaoIndex.codPredio) { (diretor, error) in
            self.infoBem.nomeResponsavel = diretor.nome
            self.infoBem.codPessoaResponsavel = diretor.identificacao
            
            self.tableView.reloadData()
        }
    }
    
    //
    // sobrescreve o método que será chamado caso o POST das informações tiver sucesso,
    // logo após o usuário tocar em FINALIZAR.
    //
    // motivo: Bem NTR deve ter 2 pendências obrigatórias: "Bem NTR" e "Alterar descrição padronizada",
    // sem dar opção ao usuário de selecionar pendências
    //
    override func postColetaSucceeded() {
        // pega na API todas as pendências
        apiCalls.getPendencias{(responseObject, error) in
            let pendencies = responseObject
            
            // mantém apenas as pendências Bem NTR (tipo 2) e Alterar Descrição Padronizada (tipo 8)
            let filteredPendencies = pendencies.filter({ (p: PendenciaModel) -> Bool in
                return p.tipo == "2" || p.tipo == "8"
            })
            
            self.postPendencies(pendencies: filteredPendencies, completion: {
                self.goodbye()
            })
        }
    }
}
