//
//  RoomController.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 23/09/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftOverlays
import BarcodeScanner
import AVFoundation

class RoomController: UITableViewController {
    
    // Row indexes
    let HELP_LABEL_INDEX = 0
    let ORGAO_INDEX = 1
    let PREDIO_INDEX = 2
    let SALA_INDEX = 3
    let BUTTONS_INDEX = 4
    
    var predioSuggestionList = Array<String>()
    var prediosList = [PredioModel]()
    var orgaoSuggestionList = Array<String>()
    var orgaosList = [PredioModel]()
    var espacofisicoSuggestionList = Array<String>()
    var espacofisicoList = [PredioModel]()
    let apiCalls = API()
    
    var orgaoAtual = PredioModel()
    var predioAtual = PredioModel()
    var espacoFisicoAtual = PredioModel()
    
    var bemCod: String = ""
    var bemInfo = BemModel()
    
    var touchedCell = -1
    
    var hasGotPredios = false
    var hasGotOrgaos = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Novo inventário"
        
        self.tableView.tableFooterView = UIView()
        
        // faz a configuração inicial do conteúdo mostrado
        DispatchQueue.main.async { self.showWaitOverlay() }
        
        let concurrentQueue = DispatchQueue(label: "com.some.concurrentQueue", attributes: .concurrent)
        
        concurrentQueue.async {
            self.setPredios {
                self.hasGotPredios = true
                print("got predios")
                if self.hasGotOrgaos { self.removeAllOverlays() }
            }
        }
        
        concurrentQueue.async {
            self.setOrgaos {
                self.hasGotOrgaos = true
                print("got orgaos")
                if self.hasGotPredios { self.removeAllOverlays() }
            }
        }
        
        // "async"
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.setPredios { print("has got predios") }
//            self.setOrgaos {
//                print("has got orgaos")
//                self.removeAllOverlays()
//            }
//        }
        
        // sync
//        self.setPredios {}
//        self.setOrgaos {
//            self.removeAllOverlays()
//            print("finalmente pegou os orgaos")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
        self.bemInfo = BemModel()
        
        if touchedCell == PREDIO_INDEX {
            self.showWaitOverlay()
            self.setEspacosFisicos {
                self.removeAllOverlays()
            }
        }
    }
    
    // recebe da API os órgãos disponíveis para o usuário logado
    private func setOrgaos(completion: @escaping () -> Void) {
        apiCalls.getLocais(completionHandler: { (orgaos, error) in
            self.orgaosList = orgaos
            
            for (_, orgao) in self.orgaosList.enumerated() {
                self.orgaoSuggestionList.append(orgao.sugestaoPredio)
            }
            
            completion()
        })
    }
    
    // recebe da API os órgãos disponíveis para o usuário logado
    private func setPredios(completion: @escaping () -> Void) {
        apiCalls.getPredios { (predios, error) in
            self.prediosList = predios
            
            for (_, predio) in self.prediosList.enumerated() {
                self.predioSuggestionList.append(predio.sugestaoPredio)
            }
            
            completion()
        }
    }
    
    // lê o json local com todos os prédios
    private func setPredios() {
        if let path = Bundle.main.path(forResource: "predios", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    
                    let predios = jsonObj["data"]["predios"]
                    
                    for (index, _) in predios {
                        let predio = PredioModel(withPredioJson: predios[Int(index)!], index: Int(index)!)
                        
                        self.prediosList.append(predio)
                        self.predioSuggestionList.append(predio.sugestaoPredio)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    // recebe da API os espaços físicos cadastrados para o predioIndex selecionado
    private func setEspacosFisicos(completion: @escaping () -> ()) {
        apiCalls.getEspacosFisicos(predio: predioIndex.codPredio, completionHandler: {(responseObject, error) in
            self.espacofisicoList = responseObject
            self.espacofisicoSuggestionList.removeAll()
            
            for espaco in self.espacofisicoList {
                self.espacofisicoSuggestionList.append(espaco.sugestaoPredio)
            }
            
            completion()
        })
    }
    
    // --------------------------------
    // TABLE VIEW METHODS
    // --------------------------------
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndex = indexPath.row
        
        switch cellIndex {
        
        // texto explicativo
        case HELP_LABEL_INDEX:
            let cell = tableView.dequeueReusableCell(withIdentifier: "helpSearchCell", for: indexPath)
            cell.isUserInteractionEnabled = false
            return cell
            
        // opções do formulário
        case ORGAO_INDEX, PREDIO_INDEX, SALA_INDEX:
            let cell = tableView.dequeueReusableCell(withIdentifier: "org-pred-sal", for: indexPath) as! SearchCell
            
            cell.nameLabel.numberOfLines = 0
            cell.nameLabel.text = ""
            cell.selectionStyle = .default
            
            if cellIndex == ORGAO_INDEX {
                cell.sectionName.text = "Órgão"
                
                if (orgaoIndex.codeIsDefined()) {
                    cell.nameLabel.text = orgaoIndex.nomePredio
                }
            }
                
            else if cellIndex == PREDIO_INDEX {
                cell.sectionName.text = "Prédio"
                
                if (predioIndex.codeIsDefined()) {
                    cell.nameLabel.text = predioIndex.nomePredio
                }
            }
                
            else if cellIndex == SALA_INDEX {
                cell.sectionName.text = "Espaço Físico"
                
                if (espacoFisicoIndex.codeIsDefined()) {
                    cell.nameLabel.text = espacoFisicoIndex.nomePredio
                }
            }
            
            return cell
            
        // view com os botões
        case BUTTONS_INDEX:
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonsCell", for: indexPath) as! SearchButtonsCell
            
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            cell.configureButtons()
            
            // add targets for buttons
            cell.barCodeButton.addTarget(self, action: #selector(self.barCodeAction), for: .touchUpInside)
            cell.manualTypeButton.addTarget(self, action: #selector(self.manualTypeAction), for: .touchUpInside)
            cell.plaquelessButton.addTarget(self, action: #selector(self.plaquelessAction), for: .touchUpInside)
            
            return cell
        
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == ORGAO_INDEX || indexPath.row == PREDIO_INDEX {
            touchedCell = indexPath.row
            performSegue(withIdentifier: "search", sender: Any?.self)
        }
            
        else if indexPath.row == SALA_INDEX {
            if predioIndex.codeIsDefined() {
                touchedCell = indexPath.row
                performSegue(withIdentifier: "search", sender: Any?.self)
            }
                
            else {
                Helper.showSimpleAlert(
                    controller: self,
                    title: "Atenção",
                    message: "Você precisa escolher um prédio antes de escolher uma sala.",
                    actionTitle: "Ok",
                    action: nil
                )
            }
        }
        
        else if indexPath.row == BUTTONS_INDEX {
            print("TOCOU NA VIEW DOS BOTÃO!!!1!!onze!")
        }
    }
    
    func didSelectItemInSearch(item: String) {
        
        switch (touchedCell) {
        case ORGAO_INDEX:
            for orgao in orgaosList {
                if orgao.sugestaoPredio == item {
                    orgaoIndex = orgao
                    break
                }
            }
            break
            
        case PREDIO_INDEX:
            for predio in prediosList {
                if predio.sugestaoPredio == item {
                    // se selecionou um prédio diferente do index
                    if (predioIndex.codPredio != predio.codPredio) {
                        // seta o novo para o index
                        predioIndex = predio
                        
                        // reseta a sala
                        espacoFisicoIndex = PredioModel()
                        espacoFisicoIndex.setUndefinedLabels()
                    }
                    break
                }
            }
            break
            
        case SALA_INDEX:
            for espacoFisico in espacofisicoList {
                if espacoFisico.sugestaoPredio == item {
                    espacoFisicoIndex = espacoFisico
                    break
                }
            }
            break
            
        default:
            break
        }
    }

    
    //
    // PREPARE FOR SEGUE
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        
        case "search":
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                
                let searchView = segue.destination as! SearchResultController
                searchView.cellTouched = touchedCell
                searchView.touchHandler = self.didSelectItemInSearch
                
                if selectedRow == ORGAO_INDEX {
                    searchView.suggestionList = self.orgaoSuggestionList
                    searchView.prediosList = self.orgaosList
                }
                
                else if selectedRow == PREDIO_INDEX {
                    searchView.suggestionList = self.predioSuggestionList
                    searchView.prediosList = self.prediosList
                
                }
                
                else if selectedRow == SALA_INDEX {
                    searchView.suggestionList = self.espacofisicoSuggestionList
                    searchView.prediosList = self.espacofisicoList
                }
            }
            
        case "beminfo":
            self.bemInfo.setColetaDate()
            self.bemInfo.setBasicFields()
            
            // limpa o campo de estado de conservação para obrigar o usuário a selecionar um
            self.bemInfo.tipoEstadoConvervcao = "null"
            self.bemInfo.descricaoEstadoConservacao = "null"
            
            let infoController = segue.destination as! BemInfoController
            infoController.infoBem = self.bemInfo
            
            break
            
        case "bemntr":
            self.bemInfo.setColetaDate()
            self.bemInfo.setBasicFields()
            
            self.bemInfo.nrPatrimonio = self.bemCod
            self.bemInfo.nomeOrgaoResponsavel = orgaoIndex.nomePredio
            
            let bemNTRController = segue.destination as! BemNTRController
            bemNTRController.infoBem = self.bemInfo
        
        case "bemsemplaca":
            self.bemInfo.setColetaDate()
            self.bemInfo.setBasicFields()
            
            self.bemInfo.nomeOrgaoResponsavel = orgaoIndex.nomePredio
            self.bemInfo.nrPatrimonio = "null"
            
            let bemSemPlacaController = segue.destination as! BemSemPlacaController
            bemSemPlacaController.infoBem = self.bemInfo
            
            break
            
        default:
            break
        }
    }
    
    
    // --------------------------------
    // BUTTON ACTIONS
    // --------------------------------
    
    func barCodeAction(sender : UIButton) {
        if !fieldsOk() {
            alertFieldMissing()
            return
        }
        print("barcode")
        let controller = BarcodeScannerController()
        
        controller.codeDelegate = self as? BarcodeScannerCodeDelegate
        controller.errorDelegate = self as? BarcodeScannerErrorDelegate
        controller.dismissalDelegate = self as? BarcodeScannerDismissalDelegate
        
        BarcodeScanner.Title.text = NSLocalizedString("Scannear patrimonio", comment: "")
        BarcodeScanner.CloseButton.text = NSLocalizedString("Fechar", comment: "")
        BarcodeScanner.SettingsButton.text = NSLocalizedString("Configuração", comment: "")
        BarcodeScanner.Info.text = NSLocalizedString(
            "Aponte a câmera para o código de barras e ele será lido.", comment: "")
        BarcodeScanner.Info.loadingText = NSLocalizedString("Looking for your product...", comment: "")
        BarcodeScanner.Info.notFoundText = NSLocalizedString("No product found.", comment: "")
        BarcodeScanner.Info.settingsText = NSLocalizedString(
            "Para usar o scanner você deve liberar o acesso à câmera.", comment: "")
        BarcodeScanner.metadata = [AVMetadataObject.ObjectType.interleaved2of5.rawValue]
        
        present(controller, animated: true, completion: nil)
    }
    
    func manualTypeAction(sender : UIButton) {
        if !fieldsOk() {
            alertFieldMissing()
            return
        }
        let alert = Helper.createInputAlert(
            title: "Consultar patrimônio",
            message: "Digite o código de barras do patrimônio que deseja consultar:",
            textFieldConfiguration: configurationTextField,
            placeholder: "",
            negativeTitle: "Cancelar",
            positiveTitle: "Ok",
            positiveCallback: { (a: UIAlertController) in
                self.bemCod = (a.textFields?[0].text)!
                self.handleCodeInput()
            }
        )
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func plaquelessAction(sender : UIButton) {
        if !fieldsOk() {
            alertFieldMissing()
            return
        }
        print("sem placa")
        self.performSegue(withIdentifier: "bemsemplaca", sender: Any?.self)
    }
    
    @IBAction func profileAction(_ sender: Any) {
        performSegue(withIdentifier: "profileSegue", sender: self)
    }
    
    // --------------------------------
    // AUXILIAR METHODS
    // --------------------------------
    
    func fieldsOk() -> Bool {
        if orgaoIndex.codeIsDefined() && predioIndex.codeIsDefined() && espacoFisicoIndex.codeIsDefined() {
            return true
        }
        return false
    }
    
    func alertFieldMissing() {
        Helper.showSimpleAlert(
            controller: self,
            title: "Atenção",
            message: "Preencha todos os campos e tente novamente",
            actionTitle: "Ok",
            action: nil
        )
    }
    
    func configurationTextField(textField: UITextField!) {
        textField.placeholder = "codigo de barras ex. 123456"
        textField.keyboardType = .numberPad
    }
    
    func handleCodeInput() {
        self.showWaitOverlay()
        
        // confere na API se o bem existe
        self.apiCalls.getInfoBem(nroPatrimonio: self.bemCod) { (bem, error) in
            self.removeAllOverlays()
            
            self.bemInfo = bem
            
            // se existir
            if bem.nrPatrimonio != "null" {
                self.performSegue(withIdentifier: "beminfo", sender: Any?.self)
                
            } else {
                // alerta que é BemNTR
                Helper.showSimpleAlert(
                    controller: self,
                    title: "O bem pesquisado não tem registro (Bem NTR)",
                    message: "",
                    actionTitle: "Ok",
                    action: { (_) in
                        // e vai pra tela adequada
                        self.performSegue(withIdentifier: "bemntr", sender: Any?.self)
                    }
                )
            }
        }
    }
}

extension RoomController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
        print(type)
        controller.dismiss(animated: true) {
            self.bemCod = code
            self.handleCodeInput()
        }
    }
}

extension RoomController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension RoomController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
