//
//  SearchController.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 11/09/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit
import BarcodeScanner
import AVFoundation

class SearchController: UIViewController {
    
    var bemCod: String = ""
    var bemInfo = BemModel()
    let apiCalls = API()

    @IBOutlet weak var digButton: UIButton!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var noPlacButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Consultar bem"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helper.configureButton(button: digButton)
        Helper.configureButton(button: readButton)
        Helper.configureButton(button: noPlacButton)
    }
    
    @IBAction func manualBarcodeAction(_ sender: Any) {
        
        let alert = Helper.createInputAlert(
            title: "Consultar patrimônio",
            message: "Digite o código de barras do patrimônio que deseja consultar:",
            textFieldConfiguration: configurationTextField,
            placeholder: "",
            negativeTitle: "Cancelar",
            positiveTitle: "Ok",
            positiveCallback: { (a: UIAlertController) in
                self.bemCod = (a.textFields?[0].text)!
                
                self.handleCodeInput(
                    positiveHandler: {
                        self.performSegue(withIdentifier: "info", sender: Any?.self)
                    },
                    negativeHandler: {
                        self.performSegue(withIdentifier: "bemntr", sender: Any?.self)
                    }
                )
            }
        )
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func scanButtonAction(_ sender: Any) {
        
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
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func bemSemPlacaAction(_ sender: Any) {
        print("bem sem placa!")
        self.performSegue(withIdentifier: "bemsemplaca", sender: Any?.self)
    }
    
    func handleCodeInput(positiveHandler: @escaping () -> Void, negativeHandler: @escaping () -> Void) {
        self.showWaitOverlay()
        
        // confere na API se o bem existe
        self.apiCalls.getInfoBem(nroPatrimonio: self.bemCod) { (bem, error) in
            self.removeAllOverlays()
            
            self.bemInfo = bem
            
            // se existir
            if bem.nrPatrimonio != "null" {
                positiveHandler()
            } else {
                negativeHandler()
            }
        }
    }
    
    func configurationTextField(textField: UITextField!) {
        textField.placeholder = "codigo de barras ex. 123456"
        textField.keyboardType = .numberPad
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // seta data e hora da coleta e dados básicos
        self.bemInfo.setColetaDate()
        self.bemInfo.setBasicFields()
        
        switch segue.identifier {
        
        case "info":
            let infoController = segue.destination as! BemInfoController
            infoController.infoBem = self.bemInfo
            
            break
            
        case "bemntr":
            self.bemInfo.nrPatrimonio = self.bemCod
            self.bemInfo.nomeOrgaoResponsavel = orgaoIndex.nomePredio
            
            let bemNTRController = segue.destination as! BemNTRController
            bemNTRController.infoBem = self.bemInfo
            
            break
            
        case "bemsemplaca":
            self.bemInfo.nomeOrgaoResponsavel = orgaoIndex.nomePredio
            
            let bemSemPlacaController = segue.destination as! BemSemPlacaController
            
            bemSemPlacaController.infoBem = self.bemInfo
            bemSemPlacaController.infoBem.clearEditables()
            bemSemPlacaController.infoBem.nrPatrimonio = "null"
            
            break
            
        default:
            break
        }
    }
}
extension SearchController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
        print(type)
        controller.dismiss(animated: true){
            self.bemCod = code
            self.performSegue(withIdentifier: "info", sender: Any?.self)
        }
    }
}

extension SearchController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension SearchController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
