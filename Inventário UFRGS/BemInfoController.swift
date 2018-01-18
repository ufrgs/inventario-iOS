//
//  Bem InfoCOntroller.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 29/09/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import UIKit
import SwiftOverlays

class BemInfoCell: UITableViewCell {
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Subtitle: UILabel!
   
}

var generalAtualSeq: String = ""

class BemInfoController: UITableViewController {
    
    let apiCalls = API()
    var infoBem = BemModel()
    var bemCod: String = ""
    
    @IBOutlet weak var pendButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Informações sobre"
        
        pendButton = setButton(button: pendButton)
        saveButton = setButton(button: saveButton)
        
        
        self.showWaitOverlay()
        apiCalls.getInfoBem(nroPatrimonio: bemCod) { (responseObject, error) in
            self.removeAllOverlays()
            self.infoBem = responseObject
            self.tableView.reloadData()
        }
        
    }
    
    func setButton(button: UIButton) -> UIButton{
        
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sub", for: indexPath) as! BemInfoCell
        
        switch indexPath.row {
        case 0:
            cell.Title.text = infoBem.nrPatrimonio
            cell.Subtitle.text = "Número do patrimonio"
            cell.Title.textColor = UIColor.lightGray
            cell.Subtitle.textColor = UIColor.lightGray
            break
        case 1:
            cell.Title.text = infoBem.nome
            cell.Subtitle.text = "Nome"
            break
        case 2:
            cell.Title.text = infoBem.marca
            cell.Subtitle.text = "Marca"
            break
        case 3:
            cell.Title.text = infoBem.modelo
            cell.Subtitle.text = "Modelo"
            break
        case 4:
            cell.Title.text = infoBem.serie
            cell.Subtitle.text = "Série"
            break
        case 5:
            cell.Title.text = infoBem.caracteristicas
            cell.Subtitle.text = "Características"
            break
        case 6:
            cell.Title.text = infoBem.nomeResponsavel
            cell.Subtitle.text = "Nome do responsável"
            cell.Title.textColor = UIColor.lightGray
            cell.Subtitle.textColor = UIColor.lightGray
            break
        case 7:
            cell.Title.text = infoBem.nomeCoResponsavel
            cell.Subtitle.text = "Nome do corresponsável"
            //cell.backgroundColor = UIColor.lightGray
            break
        case 8:
            cell.Title.text = infoBem.descricaoSituacao
            cell.Subtitle.text = "Situação"
            cell.Title.textColor = UIColor.lightGray
            cell.Subtitle.textColor = UIColor.lightGray
            break
        case 9:
            cell.Title.text = infoBem.descricaoEstadoConservacao
            cell.Subtitle.text = "Estado de conservação"
            break
        case 10:
            cell.Title.text = infoBem.obsSituacao
            cell.Subtitle.text = "Observação"
            break
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        editCell(cell: indexPath.row)
    }
    
    func editCell(cell: Int){
        
        switch cell {
        case 1:
            //cell.Title.text = infoBem.nome
            //cell.Subtitle.text = "Nome"
            
            let alert = UIAlertController(title: "Editar nome", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields![0].text = infoBem.nome
            
            alert.addAction(UIAlertAction(title: "Salvar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                print("User click Ok button")
                print(alert.textFields?[0].text! as Any)
                self.infoBem.nome = (alert.textFields?[0].text)!
                self.tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Voltar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            }))
            
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            
            break
        case 2:
            //cell.Title.text = infoBem.marca
            //cell.Subtitle.text = "Marca"
            
            let alert = UIAlertController(title: "Editar marca", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields![0].text = infoBem.marca
            
            alert.addAction(UIAlertAction(title: "Salvar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                print("User click Ok button")
                print(alert.textFields?[0].text! as Any)
                self.infoBem.marca = (alert.textFields?[0].text)!
                self.tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Voltar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            }))
            
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            
            break
        case 3:
            //cell.Title.text = infoBem.modelo
            //cell.Subtitle.text = "Modelo"
            
            let alert = UIAlertController(title: "Editar modelo", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields![0].text = infoBem.modelo
            
            alert.addAction(UIAlertAction(title: "Salvar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                print("User click Ok button")
                print(alert.textFields?[0].text! as Any)
                self.infoBem.modelo = (alert.textFields?[0].text)!
                self.tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Voltar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            }))
            
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            break
        case 4:
            //cell.Title.text = infoBem.serie
            //cell.Subtitle.text = "Série"
            
            let alert = UIAlertController(title: "Editar série", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields![0].text = infoBem.serie
            
            alert.addAction(UIAlertAction(title: "Salvar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                print("User click Ok button")
                print(alert.textFields?[0].text! as Any)
                self.infoBem.serie = (alert.textFields?[0].text)!
                self.tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Voltar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            }))
            
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            break
        case 5:
            //cell.Title.text = infoBem.caracteristicas
            //cell.Subtitle.text = "Características"
            
            let alert = UIAlertController(title: "Editar características", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields![0].text = infoBem.caracteristicas
            
            alert.addAction(UIAlertAction(title: "Salvar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                print("User click Ok button")
                print(alert.textFields?[0].text! as Any)
                self.infoBem.caracteristicas = (alert.textFields?[0].text)!
                self.tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Voltar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            }))
            
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            break
            
        case 7:
            let alert = UIAlertController(title: "Novo corresponável", message: "Digite o cartão do novo corresponsável:", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields![0].text = ""
            
            alert.addAction(UIAlertAction(title: "Pesquisar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                
                var novoCo = IdentificacaoModel()
                
                self.showWaitOverlay()
                self.apiCalls.getPessoaBasico(cartao: alert.textFields![0].text!){ (responseObj, error) in
                    self.removeAllOverlays()
                    novoCo = responseObj
                    
                    if responseObj.nome == "null"{
                        novoCo.nome = "não encontrado"
                    }
                    
                    self.newAlert(persona: novoCo)
                    
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "Voltar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            }))
            
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            break
        case 9:
            //cell.Title.text = infoBem.descricaoEstadoConservacao
            //cell.Subtitle.text = "Estado de conservação"
            
            let alert = UIAlertController(title: "Editar estado de conservação", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "Bom", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                
                self.infoBem.tipoEstadoConvervcao = "2"
                self.infoBem.descricaoEstadoConservacao = "BOM"
                self.tableView.reloadData()
                
            }))
            alert.addAction(UIAlertAction(title: "Inservível", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                
                self.infoBem.tipoEstadoConvervcao = "5"
                self.infoBem.descricaoEstadoConservacao = "INSERVÍVEL"
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Necessita reparos", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                
                self.infoBem.tipoEstadoConvervcao = "4"
                self.infoBem.descricaoEstadoConservacao = "NECESSITA REPAROS"
                self.tableView.reloadData()
                
            }))
            alert.addAction(UIAlertAction(title: "Novo", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                
                self.infoBem.tipoEstadoConvervcao = "1"
                self.infoBem.descricaoEstadoConservacao = "NOVO"
                self.tableView.reloadData()
                
                
            }))
            alert.addAction(UIAlertAction(title: "Peça para museu", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                
                self.infoBem.tipoEstadoConvervcao = "6"
                self.infoBem.descricaoEstadoConservacao = "PEÇA P/ MUSEU"
                self.tableView.reloadData()
                
                
            }))
            alert.addAction(UIAlertAction(title: "Regular", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                
                self.infoBem.tipoEstadoConvervcao = "3"
                self.infoBem.descricaoEstadoConservacao = "REGULAR"
                self.tableView.reloadData()
                
                
            }))
            alert.addAction(UIAlertAction(title: "Sucata", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                
                self.infoBem.tipoEstadoConvervcao = "7"
                self.infoBem.descricaoEstadoConservacao = "SUCATA"
                self.tableView.reloadData()
                
                
            }))
            alert.addAction(UIAlertAction(title: "Voltar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            }))
            
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            break
        case 10:
            //cell.Title.text = infoBem.obsSituacao
            //cell.Subtitle.text = "Observação"
            
            let alert = UIAlertController(title: "Editar observação", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields![0].text = infoBem.obsSituacao
            
            alert.addAction(UIAlertAction(title: "Salvar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                print("User click Ok button")
                print(alert.textFields?[0].text! as Any)
                self.infoBem.obsSituacao = (alert.textFields?[0].text)!
                self.tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Voltar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            }))
            
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            
            break
        default:
            break
        }
    }
    
    @IBAction func contAction(_ sender: Any) {
        
        self.showWaitOverlay()
        apiCalls.postColetaInventario(infoBem: infoBem) { (responseObject, error) in
            self.removeAllOverlays()
            self.performSegue(withIdentifier: "pendencias", sender: Any?.self)
        }
        
    }

    @IBAction func finaliAction(_ sender: Any) {
        
        self.showWaitOverlay()
        apiCalls.postColetaInventario(infoBem: infoBem) { (responseObject, error) in
            self.removeAllOverlays()
            novaConsulta = 1
            if code == "201"
            {
            _ = self.navigationController?.popToRootViewController(animated: true)
            }
            
            else {
                
                let alert = UIAlertController(title: "Erro:", message: responseObject, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                }))
                
                self.present(alert, animated: true, completion: {
                    print("completion block")
                })
                
            }
        }
        
    }
    
    func newAlert(persona: IdentificacaoModel){
        let alert = UIAlertController(title: "Resultado", message: persona.nome, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Confirmar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            self.infoBem.codPessoaCoResponsavel = persona.identificacao
            self.infoBem.nomeCoResponsavel = persona.nome
            self.tableView.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: "Voltar", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
}


