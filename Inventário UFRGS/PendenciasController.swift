//
//  PendenciasController.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 03/10/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import UIKit
import SwiftOverlays

class PendenciasController: UITableViewController {
    
    let apiCalls = API()
    var pendencias = [PendenciaModel]()
    
    @IBOutlet weak var pendButt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCalls.getPendencias{(responseObject, error) in
            self.pendencias = responseObject
            self.tableView.reloadData()
        }
        
        pendButt = setButton(button: pendButt)
        
        self.title = "Editar pendências"
        
        
    }
    
    func setButton(button: UIButton) -> UIButton{
        
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }
    @IBAction func finalAction(_ sender: Any) {
        
        novaConsulta = 1
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendencias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pend", for: indexPath)
        
        cell.textLabel?.text = pendencias[indexPath.row].nome
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        self.showWaitOverlay()
        apiCalls.postPendencia(seq: generalAtualSeq, pend: pendencias[indexPath.row].tipo) { (responseObj, error) in
            self.removeAllOverlays()
            novaConsulta = 1
            
            let alert = UIAlertController(title: "Pendências", message: "Pendência adicionada com sucesso!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
               // _ = self.navigationController?.popToRootViewController(animated: true)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}



