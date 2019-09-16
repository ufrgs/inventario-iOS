//
//  BemSemPlacaController.swift
//  Inventário UFRGS
//
//  Created by Augusto on 04/09/2018.
//  Copyright © 2018 CPD UFRGS. All rights reserved.
//

import UIKit
import SwiftOverlays

class BemSemPlacaController: BemInfoController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        self.title = "Bem sem placa"
        self.grayed = [true, false, false, false, false, false, false, false, false, false, false, false]
        
        self.infoBem.nrPatrimonio = "null"
        
        // pega o nome do diretor do Órgão selecionado e o coloca como responsável do Bem
        apiCalls.getOrgaoDiretor(codOrgao: orgaoIndex.codPredio) { (diretor, error) in
            self.infoBem.nomeResponsavel = diretor.nome
            self.infoBem.codPessoaResponsavel = diretor.identificacao
            
            self.tableView.reloadData()
        }
    }
    
    override func finalizeAction(_ sender: Any) {

        let fieldsOkHandler = {
            // usuário deve selecionar uma pendência dentre as disponíveis
            self.selectPendency(
                // caso selecione corretamente, será feita a tentativa de postar a coleta
                successCompletion: {
                    print("tudo certo, vai tentar postar a coleta")
                    self.tryPostColeta(successCallback: self.goodbye)
                    
                // caso cancele, alerta que deve selecionar para finalizar coleta
                }, failCompletion: {
                    self.alertPendencyIsObrigatory()
                }
            )
        }
        
        checkFields(okHandler: fieldsOkHandler)
    }
    
    // obriga o usuário a selecionar uma das seguintes pendências para poder fazer o post:
    //
    //    Bem Sem Cadastro a Resolver
    //    Bem Sem Cadastro com Documentação Localizada
    //    Marca de Placa Caída (MPC)
    //
    func selectPendency(successCompletion: @escaping () -> (), failCompletion: @escaping () -> ()) {
        
        let postPendency = { (pendency: PendenciaModel) in
            self.apiCalls.postPendencia(seq: generalAtualSeq, pend: pendency.tipo) { (responseObj, error) in
                self.removeAllOverlays()
                novaConsulta = 1
                
                print("> postei a pendencia \(pendency.tipo): \(pendency.nome)")
                
                // executa o callback que recebeu caso tudo der certo
                successCompletion()
            }
        }
        
        let createSelectionAlert = { (pendencies: [PendenciaModel]) -> UIAlertController in
            let alert = UIAlertMultiLine(title: "Pendências", message: "Selecione uma das pendências a seguir para continuar", preferredStyle: .alert)
            
            for p in pendencies {
                let action = UIAlertAction(title: p.nome, style: .default, handler: { (action: UIAlertAction) in
                    postPendency(p)
                })
                alert.addAction(action)
            }
            
            let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: { (UIAlertAction) in
                print("cancelou")
                failCompletion()
            })
            
            alert.addAction(cancel)
            
            return alert
        }
        
        // pega na API todas as pendências
        apiCalls.getPendencias{(responseObject, error) in
            let pendencies = responseObject
            
            // mantém apenas as pendências tipo 1,5 e 9
            let filteredPendencies = pendencies.filter({ (p: PendenciaModel) -> Bool in
                print(p.tipo)
                return p.tipo == "1" || p.tipo == "5" || p.tipo == "9"
            })
            
            let alert = createSelectionAlert(filteredPendencies)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func alertPendencyIsObrigatory() {
        let alert = UIAlertController(title: "Erro ao postar coleta", message: "É necessário selecionar uma das pendências disponíveis. Toque novamente em finalizar para escolher as pendências e finalizar a coleta.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

