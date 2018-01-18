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

    @IBOutlet weak var digButton: UIButton!
    @IBOutlet weak var readButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        digButton = setButton(button: digButton)
        readButton = setButton(button: readButton)
        
        self.title = "Consultar bem"
        
    }
    
    func setButton(button: UIButton) -> UIButton{
        
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }
    
    override func  didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func manualBarcodeAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Consultar patrimônio", message: "Digite o código de barras do patrímonio que deseja consultar:", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            self.bemCod = (alert.textFields?[0].text)!
            self.performSegue(withIdentifier: "info", sender: Any?.self)
        }))
        
        alert.addAction(UIAlertAction(title: "Voltar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
        })
        
    }
    
    @IBAction func scanButtonAction(_ sender: Any) {
        
        let controller = BarcodeScannerController()
        controller.codeDelegate = self as? BarcodeScannerCodeDelegate
        controller.errorDelegate = self as? BarcodeScannerErrorDelegate
        controller.dismissalDelegate = self as? BarcodeScannerDismissalDelegate
        BarcodeScanner.Title.text = NSLocalizedString("Scanear patrimonio", comment: "")
        BarcodeScanner.CloseButton.text = NSLocalizedString("Fechar", comment: "")
        BarcodeScanner.SettingsButton.text = NSLocalizedString("Configuração", comment: "")
        BarcodeScanner.Info.text = NSLocalizedString(
            "Aponte a camera para o código de barras e ele será lido automaticamente.", comment: "")
        BarcodeScanner.Info.loadingText = NSLocalizedString("Looking for your product...", comment: "")
        BarcodeScanner.Info.notFoundText = NSLocalizedString("No product found.", comment: "")
        BarcodeScanner.Info.settingsText = NSLocalizedString(
            "Para usar o scaner você deve liberar o acesso á câmera.", comment: "")
        BarcodeScanner.metadata = [AVMetadataObjectTypeInterleaved2of5Code]
        
        present(controller, animated: true, completion: nil)
    }
    
    
    func configurationTextField(textField: UITextField!){
        textField.placeholder = "codigo de barras ex. 123456"
        textField.keyboardType = .numberPad
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let infoController = segue.destination as! BemInfoController
        infoController.bemCod = self.bemCod
    }
    
    
    
}
extension SearchController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        controller.dismiss(animated: true){
            self.bemCod = code
            self.performSegue(withIdentifier: "info", sender: Any?.self)
        }
    }
}

extension SearchController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
    }
}

extension SearchController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
