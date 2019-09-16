//
//  Bem InfoController.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 29/09/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation
import UIKit
import SwiftOverlays
import SwiftyJSON

class BemInfoCell: UITableViewCell {
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Subtitle: UILabel!
    
    func configure(isGray: Bool) {
        self.Title.numberOfLines = 0
        
        if isGray {
            self.Title.textColor = UIColor.lightGray
            self.Subtitle.textColor = UIColor.lightGray
        } else {
            self.Title.textColor = UIColor.black
            self.Subtitle.textColor = UIColor.black
        }
    }
}

var generalAtualSeq: String = ""

class BemInfoController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let apiCalls = API()
    var infoBem = BemModel()
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var grayed = [true, true, true, true, false, false, false, false, false, false, false, false]
    
    var situacoes = [SituacaoModel]()
    var estados = [EstadoConservacaoModel]()
    var descricoes = [DescricaoBemModel]()
    
    var descricoesSuggestions = [String]()
    
    let bemOciosoLabels = ["S" : "Sim",
                           "N" : "Não"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helper.configureButton(button: saveButton)
        
        // acessos à API -------------------------------
        // otimizar?
        apiCalls.getSituacoesBens { (s: [SituacaoModel], _) in
            self.situacoes = s
        }
        
        apiCalls.getEstadosConservacaoBens { (e: [EstadoConservacaoModel], _) in
            self.estados = e
        }
        
        apiCalls.getBemDescricoes { (d: [DescricaoBemModel], _) in
            self.descricoes = d
            
            self.descricoesSuggestions = d.map { (descricao: DescricaoBemModel) -> String in
                return descricao.descricaoPadronizada
            }
        }
        // ---------------------------------------------
        
        self.configure()
    }
    
    // --------------------------------
    // CONFIGURE
    // --------------------------------
    
    func configure() {
        self.title = "Informações sobre"
        
        if (!self.orgaoIsCorrect()) {
            self.alertIncorrectOrgao()
        }
    }
    
    // --------------------------------
    // TABLE VIEW METHODS
    // --------------------------------
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sub", for: indexPath) as! BemInfoCell
        let gray = grayed[indexPath.row]
        
        cell.configure(isGray: gray)
        
        switch indexPath.row {
        case 0:
            cell.Subtitle.text = "Número do patrimônio"
            cell.Title.text = createCellLabel(text: infoBem.nrPatrimonio)
            break
            
        case 1:
            cell.Subtitle.text = "Situação"
            cell.Title.text = createCellLabel(text: infoBem.descricaoSituacao)
            break
            
        case 2:
            cell.Subtitle.text = "Nome do órgão responsável"
            cell.Title.text = createCellLabel(text: infoBem.nomeOrgaoResponsavel)
            break
            
        case 3:
            cell.Subtitle.text = "Nome do responsável"
            cell.Title.text = createCellLabel(text: infoBem.nomeResponsavel)
            break
            
        case 4:
            cell.Subtitle.text = "Nome do corresponsável"
            cell.Title.text = createCellLabel(text: infoBem.nomeCoResponsavel)
            break
            
        case 5:
            cell.Subtitle.text = "Descrição padronizada"
            cell.Title.text = createCellLabel(text: infoBem.nome)
            break
            
        case 6:
            cell.Subtitle.text = "Marca"
            cell.Title.text = createCellLabel(text: infoBem.marca)
            break
            
        case 7:
            cell.Subtitle.text = "Modelo"
            cell.Title.text = createCellLabel(text: infoBem.modelo)
            break
            
        case 8:
            cell.Subtitle.text = "Série"
            cell.Title.text = createCellLabel(text: infoBem.serie)
            break
            
        case 9:
            cell.Subtitle.text = "Características"
            cell.Title.text = createCellLabel(text: infoBem.caracteristicas)
            break
            
        case 10:
            cell.Subtitle.text = "Estado de conservação"
            cell.Title.text = createCellLabel(text: self.infoBem.descricaoEstadoConservacao)
            break
            
        case 11:
            cell.Subtitle.text = "Bem está ocioso"
            cell.Title.text = createCellLabel(text: bemOciosoLabels[self.infoBem.indicadorOcioso]!)
            break

        default:
            break
        }
        
        cell.Subtitle.text = cell.Subtitle.text?.uppercased()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // se a célula escolhida estiver desabilitada, não faz nada
        if grayed[indexPath.row] {
            return
        }
        
        switch indexPath.row {
        case 0:
            self.editGeneralCell(fieldName: "número do patrimônio", placeholder: self.infoBem.nrPatrimonio) { (text: String) in
                self.infoBem.nrPatrimonio = text
                self.tableView.reloadData()
            }
            break
        
        case 1:
            self.editSituacaoCell()
            break
            
        case 2:
//            self.editGeneralCell(fieldName: "órgão responsável", placeholder: self.infoBem.nomeOrgaoResponsavel) { (a: UIAlertController) in
//                // TODO: similar ao corresponsável: procurar na API o código/nome do prédio?
//                self.tableView.reloadData()
//            }
            break
            
        case 3:
            self.editPersonCell(role: "responsável") { (person: IdentificacaoModel) in
                self.infoBem.codPessoaResponsavel = person.identificacao
                self.infoBem.nomeResponsavel = person.nome
                self.tableView.reloadData()
            }
            break
            
        case 4:
            self.editPersonCell(role: "coresponsável") { (person: IdentificacaoModel) in
                self.infoBem.codPessoaCoResponsavel = person.identificacao
                self.infoBem.nomeCoResponsavel = person.nome
                self.tableView.reloadData()
            }
            
            break
            
        case 5:
            // instancia uma SearchResultController para selecionar dentro da lista enorme de possíveis Descrições Padronizadas
            if let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchResultController") as? SearchResultController {
                resultsController.touchHandler = self.didSelectDescricaoPadronizadaHandler
                resultsController.suggestionList = self.descricoesSuggestions
                
                // mostra ela
                self.navigationController?.pushViewController(resultsController, animated: true)
            }
            
            break
            
        case 6:
            self.editGeneralCell(fieldName: "marca", placeholder: self.infoBem.marca) { (text: String) in
                self.infoBem.marca = text
                self.tableView.reloadData()
            }
            break
            
        case 7:
            self.editGeneralCell(fieldName: "modelo", placeholder: self.infoBem.modelo) { (text: String) in
                self.infoBem.modelo = text
                self.tableView.reloadData()
            }
            break
            
        case 8:
            self.editGeneralCell(fieldName: "série", placeholder: self.infoBem.serie) { (text: String) in
                self.infoBem.serie = text
                self.tableView.reloadData()
            }
            break
            
        case 9:
            self.editGeneralCell(fieldName: "características", placeholder: self.infoBem.caracteristicas) { (text: String) in
                self.infoBem.caracteristicas = text
                self.tableView.reloadData()
            }
            break
            
        case 10:
            self.editEstadoConservacaoCell()
            break
            
        case 11:
            self.editBemOciosoCell()
            break

        default:
            break
        }
    }
    
    // --------------------------------
    // EDIT CELL FUNCTIONS
    // --------------------------------
    
    func editGeneralCell(fieldName: String, placeholder: String, handler: @escaping (String) -> ()) {
        var newPlaceholder = placeholder
        
        if placeholder == "null" {
            newPlaceholder = ""
        }
        
        let alert = Helper.createInputAlert(
            title: "Editar " + fieldName,
            message: "",
            placeholder: newPlaceholder,
            negativeTitle: "Cancelar",
            positiveTitle: "Salvar",
            positiveCallback: { (a: UIAlertController) in
                let text = a.textFields![0].text!
                if text != "" && text != "null" {
                    handler(text)
                }
            }
        )
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func editPersonCell(role: String, callbackIfFound: @escaping (IdentificacaoModel) -> ()) {
        // cria alerta pedindo cartão ou nome da pessoa em questão
        let alert = Helper.createInputAlert(
            title: "Novo " + role,
            message: "Digite o cartão ou nome do novo "  + role + ":",
            placeholder: "",
            negativeTitle: "Cancelar",
            positiveTitle: "Pesquisar",
            positiveCallback: { (a: UIAlertController) in
                SwiftOverlays.showCenteredWaitOverlay(self.view.superview!)
                self.searchPerson(input: a.textFields![0].text!, callbackIfFound: callbackIfFound)
            }
        )
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func searchPerson(input: String, callbackIfFound: @escaping (IdentificacaoModel) -> ()) {
        
        // --- callbakcs para os possíveis resultados da busca ---
        
        let notFound = { () in
            Helper.showSimpleAlert(
                controller: self,
                title: "Resultado",
                message: "Não encontrado",
                actionTitle: "Ok",
                action: nil
            )
        }
        
        let foundOnePerson = { (person: IdentificacaoModel) in
            Helper.showAlertTwoOptions(
                controller: self,
                title: "Resultado",
                message: person.nome,
                negativeTitle: "Cancelar",
                negativeAction: nil,
                positiveTitle: "Confirmar",
                positiveAction: { (UIAlertAction) in
                    callbackIfFound(person)
                }
            )
        }
        
        let foundSeveralPeople = { (people: [IdentificacaoModel]) in
            let alert = UIAlertController(title: "Resultado", message: "Selecione a pessoa", preferredStyle: .alert)
            
            for p in people {
                alert.addAction(UIAlertAction(title: p.nome, style: .default, handler: { (UIAlertAction) in
                    callbackIfFound(p)
                }))
            }
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        // --- callbacks para os dois tipos de busca: por cartão e por nome ---
        
        let cartaoSearchCompletion = { (person: IdentificacaoModel, error: Error?) in
            Helper.removeLoading(view: self.view)
            
            if (person.nome == "null") {
                notFound()
            } else {
                foundOnePerson(person)
            }
        }
        
        let nomeSearchCompletion = { (people: [IdentificacaoModel], error: Error?) in
            Helper.removeLoading(view: self.view)
            
            if people.count == 1 {
                foundOnePerson(people[0])
            } else if people.count > 1 {
                foundSeveralPeople(people)
            } else {
                notFound()
            }
        }
        
        // --- chama a API de acordo com o tipo de busca ---
        
        if isNumbersOnly(text: input) {
            self.apiCalls.getPessoaBasico(cartao: input, completionHandler: cartaoSearchCompletion)
            // senão, fornece um nome
        } else {
            self.apiCalls.getPessoasBasico(nome: input, completionHandler: nomeSearchCompletion)
        }
    }
    
    func editSituacaoCell() {
        let alert = UIAlertController(title: "Editar situação", message: "", preferredStyle: .actionSheet)
        
        for i in 0..<self.situacoes.count {
            alert.addAction(UIAlertAction(title: self.situacoes[i].descricaoSituacao, style: .default, handler:{ (UIAlertAction) in
                self.infoBem.tipoSituacao = self.situacoes[i].tipoSituacao
                self.infoBem.descricaoSituacao = self.situacoes[i].descricaoSituacao
                
                self.tableView.reloadData()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func editEstadoConservacaoCell() {
        let alert = UIAlertController(title: "Editar estado de conservação", message: "", preferredStyle: .actionSheet)
        
        for i in 0..<self.estados.count {
            alert.addAction(UIAlertAction(title: self.estados[i].descricaoEstadoConservacao, style: .default, handler:{ (UIAlertAction) in
                self.infoBem.descricaoEstadoConservacao = self.estados[i].descricaoEstadoConservacao
                self.infoBem.tipoEstadoConvervcao = self.estados[i].tipoEstadoConservacao
                
                self.tableView.reloadData()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func editBemOciosoCell() {
        let alert = UIAlertController(title: "O bem está ocioso?", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler:{ (UIAlertAction)in
            self.infoBem.indicadorOcioso = "S"
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Não", style: .default, handler:{ (UIAlertAction)in
            self.infoBem.indicadorOcioso = "N"
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didSelectDescricaoPadronizadaHandler(item: String) {
        for descricao in self.descricoes {
            if descricao.descricaoPadronizada == item {
                self.infoBem.nome = descricao.descricaoPadronizada
                self.infoBem.codDescricao = descricao.codigoDescricao
                
                self.tableView.reloadData()
                
                break
            }
        }
    }
    
    // --------------------------------
    // IBACTIONS
    // --------------------------------

    @IBAction func finalizeAction(_ sender: Any) {
        checkFields(okHandler: {
            // tenta enviar os dados coletados
            self.tryPostColeta(successCallback: self.postColetaSucceeded)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "pendencias":
            // pega na API as pendências que serão mostradas na PendenciasController
            apiCalls.getPendencias{(responseObject, error) in
                let pendenciasController = segue.destination as! PendenciasController
                pendenciasController.pendencias = responseObject
                
                pendenciasController.tableView.reloadData()
            }
            
        default:
            break
        }
    }
    
    // --------------------------------
    // AUXILIAR METHODS
    // --------------------------------
    
    private func isNumbersOnly(text: String) -> Bool {
        let set = CharacterSet(charactersIn: text)
        
        return CharacterSet.decimalDigits.isSuperset(of: set)
    }
    
    private func orgaoIsCorrect() -> Bool  {
        return self.infoBem.nomeOrgaoResponsavel == orgaoIndex.nomePredio
    }
    
    func estadoConservacaoIsSelected() -> Bool {
        return (self.infoBem.tipoEstadoConvervcao != "0" &&
                self.infoBem.tipoEstadoConvervcao != "null" &&
                self.infoBem.tipoEstadoConvervcao != "")
    }
    
    func textualFieldIsOk(field: String) -> Bool {
        return field != "null" && field != ""
    }
    
    func checkFields(okHandler: () -> ()) {
        var problematicFields = [String]()
        
        if (!textualFieldIsOk(field: self.infoBem.tipoSituacao)) {
            problematicFields.append("Situação")
        }
        
        if (!textualFieldIsOk(field: self.infoBem.codPessoaResponsavel)) {
            problematicFields.append("Responsável")
        }
        
        print(self.infoBem.codPessoaCoResponsavel)
        if (!textualFieldIsOk(field: self.infoBem.codPessoaCoResponsavel)) {
            problematicFields.append("Co-responsável")
        }
        
        if (!textualFieldIsOk(field: self.infoBem.caracteristicas)) {
            problematicFields.append("Características")
        }
        
        if (!estadoConservacaoIsSelected()) {
            problematicFields.append("Estado de Conservação")
        }
        
        
        // se houver ao menos 1 item com problema
        if problematicFields.count > 0 {
            var message = ""
            
            // se for apenas 1 item
            if problematicFields.count == 1 {
                message = "O campo \(problematicFields[0]) deve ser preenchido."
            
            // se for mais de 1 item
            } else {
                message = "Os seguintes campos devem ser preenchidos:\n"
                
                // passa por todos menos o último
                for i in (0...(problematicFields.count - 2)) {
                    message += problematicFields[i] + ", "
                }
                
                // no último não coloca vírgula depois e coloca ponto final
                message += problematicFields.last! + "."
            }
            
            print(message)
            
            Helper.showSimpleAlert(
                controller: self,
                title: "Erro",
                message: message,
                actionTitle: "Ok",
                action: nil
            )
            
        } else {
            okHandler()
        }
    }
    
    func tryPostColeta(successCallback: @escaping () -> ()) {
        Helper.showLoading(view: self.view)
        
        apiCalls.postColetaInventario(infoBem: infoBem) { (responseObject, error) in
            Helper.removeLoading(view: self.view)
            
            novaConsulta = 1
            
            // se chegar um código de erro
            if self.apiCalls.getCode() != "201" {
                var message = "Algum erro aconteceu."
                let json = JSON.init(parseJSON: responseObject)
                
                if let erros = json["data"]["erros"].arrayObject {
                    // se há algum erro no array, reseta a mensagem
                    if erros.count > 0 { message = "" }
                    
                    // para cada array de erros
                    for array in erros {
                        let a = array as! [String]
                        
                        // concatena todas as mensagens daquele array de erros
                        for m in a {
                            message += "\n\n"
                            message += String(describing: m)
                        }
                    }
                }
                
                Helper.showSimpleAlert(
                    controller: self,
                    title: "Erro(s):",
                    message: message,
                    actionTitle: "Ok",
                    action: nil)
                
            // se o post foi sucesso
            } else {
                successCallback()
            }
        }
    }
    
    func postColetaSucceeded() {
        // pergunta ao usuário se a descrição do bem está correta
        self.askIfDescriptionIsCorrect(
            
            // se estiver, volta para a tela anterior
            yesHandler: {
                self.goodbye()
            
            // caso contrário, posta a pendência obrigatória: "Alterar descrição padronizada"
            }, noHandler: {
                let pendency = PendenciaModel(
                    nome: "Alterar Descrição Padronizada",
                    tipo: "8",
                    seq: ""
                )
                
                self.postPendencies(pendencies: [pendency], completion: {
                    Helper.showSimpleAlert(
                        controller: self,
                        title: "Foi adicionada uma pendência para alterar a descrição padronizada desse bem",
                        message: "",
                        actionTitle: "Ok",
                        action: { (_) in
                            self.goodbye()
                        })
                })
            }
        )
    }
    
    private func askIfDescriptionIsCorrect(yesHandler: @escaping () -> Void, noHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "A descrição do bem está correta?", message: "", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Sim", style: .default, handler: { (UIAlertAction) in yesHandler() })
        let no = UIAlertAction(title: "Não", style: .default, handler: { (UIAlertAction) in noHandler() })
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(yes)
        alert.addAction(no)
        alert.addAction(cancel)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func postPendencies(pendencies: [PendenciaModel], completion: @escaping () -> ()) {
        // se ainda houver pendências
        if pendencies.count > 0 {
            
            let first = pendencies[0]
            
            apiCalls.postPendencia(seq: generalAtualSeq, pend: first.tipo) { (responseObj, error) in
                
                // se houve algum erro
                if self.apiCalls.getCode() != "201" {
                    
                    Helper.showSimpleAlert(
                        controller: self,
                        title: "Erro",
                        message: "Ocorreu um erro ao postar a(s) pendência(s). Por favor, tente novamente.",
                        actionTitle: "Ok",
                        action: nil)
                    
                    return
                }
                
                self.removeAllOverlays()
                novaConsulta = 1
                
                print("> postei a pendencia \(first.tipo): \(first.nome)")
                
                // remove o primeiro elemento do array
                var remaining = pendencies
                remaining.removeFirst()
                
                // chama a função recursivamente, agora sem o primeiro elemento
                self.postPendencies(pendencies: remaining, completion: completion)
            }
            
        // se chegou ao final, executa o callback
        } else {
            completion()
        }
    }
    
    func alertIncorrectOrgao() {
        Helper.showSimpleAlert(
            controller: self,
            title: "Atenção!",
            message: "O bem pesquisado não pertence ao órgão de referência selecionado inicialmente.",
            actionTitle: "Ok",
            action: nil
        )
    }
    
    func alertEstadoConservacaoUnselected() {
        let alert = UIAlertController(title: "Atenção!", message: "Um estado de conservação deve ser selecionado.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertCaracteristicasNotInformed() {
        let alert = UIAlertController(title: "Atenção!", message: "O campo \"Características\" deve ser preenchido.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func createCellLabel(text: String) -> String {
        if text == "null" || text == "" {
            return "-"
        }
        return text
    }
    
    func goodbye() {
        if let superview = self.view.superview {
            SwiftOverlays.showTextOverlay(superview, text: "Coleta feita com sucesso!")
            
            // espera um pouco e volta pra tela anterior
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                SwiftOverlays.removeAllOverlaysFromView(superview)
                
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
