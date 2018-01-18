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

class RoomController: UITableViewController {
    
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
    
    var touchedCell = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
        self.title = "Local"
        
        setPrediosAndOrgaos()
        
        predioIndex.codPredio = "xxxxx"
        predioIndex.nomePredio = "prédio não especificado"
        orgaoIndex.codPredio = "xxxxx"
        orgaoIndex.nomePredio = "prédio não especificado"
        espacoFisicoIndex.codPredio = "xxxxx"
        espacoFisicoIndex.nomePredio = "prédio não especificado"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
        if touchedCell == 1 {
            self.showWaitOverlay()
            apiCalls.getEspacosFisicos(predio: predioIndex.codPredio, completionHandler: {(responseObject, error) in
                self.removeAllOverlays()
                self.espacofisicoList = responseObject
                for espaco in self.espacofisicoList {
                    self.espacofisicoSuggestionList.append(espaco.sugestaoPredio)
                }
            })
        }
        
    }
    
    func setPrediosAndOrgaos(){
        self.showWaitOverlay()
        if let path = Bundle.main.path(forResource: "predios", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    
                    let predios = jsonObj["data"]["predios"]
                    let orgaos = jsonObj["data"]["orgaos"]
                    
                    for (index, _) in predios{
                        
                        let predioAtual = PredioModel()
                        predioAtual.codPredio = String(describing: predios[Int(index)!]["CodPredio"])
                        predioAtual.nomePredio = String(describing: predios[Int(index)!]["NomePredio"])
                        predioAtual.indexPredio = Int(index)!
                        predioAtual.sugestaoPredio = predioAtual.codPredio + " - " + predioAtual.nomePredio
                        
                        self.predioSuggestionList.append(predioAtual.codPredio + " - " + predioAtual.nomePredio)
                        
                        prediosList.append(predioAtual)
                        
                    }
                    
                    for (index, _) in orgaos{
                        
                        let orgaoAtual = PredioModel()
                        orgaoAtual.codPredio = String(describing: orgaos[Int(index)!]["CodOrgao"])
                        orgaoAtual.nomePredio = String(describing: orgaos[Int(index)!]["NomeOrgao"])
                        orgaoAtual.codSemantico = String(describing: orgaos[Int(index)!]["SiglaOrgao"])
                        orgaoAtual.indexPredio = Int(index)!
                        orgaoAtual.sugestaoPredio = orgaoAtual.codSemantico + " - " + orgaoAtual.nomePredio
                        
                        self.orgaoSuggestionList.append(orgaoAtual.codSemantico + " - " + orgaoAtual.nomePredio)
                        
                        orgaosList.append(orgaoAtual)
                    }
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        self.removeAllOverlays()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "org-pred-sal", for: indexPath) as! SearchCell
        let cellIndex = indexPath.row
        
        if cellIndex == 0 {
            cell.sectionName.text = "Orgão"
            cell.codeLabel.text = orgaoIndex.codPredio
            cell.nameLabel.text = orgaoIndex.nomePredio
            cell.clickLabel.text = "PROCURAR ORGÃO"
        }
        
        else if cellIndex == 1 {
            cell.sectionName.text = "Prédio"
            cell.codeLabel.text = predioIndex.codPredio
            cell.nameLabel.text = predioIndex.nomePredio
            cell.clickLabel.text = "PROCURAR PRÉDIO"
        }
            
        else if cellIndex == 2 {
            cell.sectionName.text = "Sala"
            cell.codeLabel.text = espacoFisicoIndex.codPredio
            cell.nameLabel.text = espacoFisicoIndex.nomePredio
            cell.clickLabel.text = "PROCURAR SALA"
        }
        
        else if cellIndex == 3 {
            cell.sectionName.text = ""
            cell.codeLabel.text = ""
            cell.nameLabel.text = ""
            cell.nameName.text = ""
            cell.codeName.text = ""
            cell.clickLabel.text = "CONTINUAR"
        }
        
        cell.clickLabel.layer.cornerRadius = 20
        cell.clickLabel.layer.borderWidth = 1
        cell.clickLabel.layer.borderColor = UIColor.white.cgColor
        cell.clickLabel.layer.masksToBounds = true
        
        return cell
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == 1{
            touchedCell = indexPath.row
            performSegue(withIdentifier: "search", sender: Any?.self)
        }
            
        else if indexPath.row == 2 {
            if predioIndex.codPredio != "xxxxx"{
                touchedCell = indexPath.row
                performSegue(withIdentifier: "search", sender: Any?.self)
               
            }
            else {
                let alert = UIAlertController(title: "Atenção", message: "Você precisa escolher um prédio antes de escolher uma sala.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        else if indexPath.row == 3{
            if orgaoIndex.codPredio != "xxxxx" && predioIndex.codPredio != "xxxxx" && espacoFisicoIndex.codPredio != "xxxxx"{
                 performSegue(withIdentifier: "cont", sender: Any?.self)
            }
            
            else{
                
                let alert = UIAlertController(title: "Atenção", message: "Preencha todos os campos e tente novamente", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let selectedRow = indexPath.row
            if selectedRow == 0{
                let searchView = segue.destination as! SearchResultController
                searchView.suggestionList = self.orgaoSuggestionList
                searchView.prediosList = self.orgaosList
                searchView.cellTouched = touchedCell
            }
            else if selectedRow == 1{
                let searchView = segue.destination as! SearchResultController
                searchView.suggestionList = self.predioSuggestionList
                searchView.prediosList = self.prediosList
                searchView.cellTouched = touchedCell
                
            }
            else if selectedRow == 2{
                let searchView = segue.destination as! SearchResultController
                searchView.suggestionList = self.espacofisicoSuggestionList
                searchView.cellTouched = self.touchedCell
                searchView.prediosList = self.espacofisicoList
            }
            else if selectedRow == 3{
                
            }
        }
    }
}
