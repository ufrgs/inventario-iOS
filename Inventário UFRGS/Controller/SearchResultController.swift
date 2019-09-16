//
//  ViewController.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 11/09/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import UIKit
import SwiftyJSON

var orgaoIndex = PredioModel()
var predioIndex = PredioModel()
var espacoFisicoIndex = PredioModel()

class SearchResultController: UIViewController, ModernSearchBarDelegate {
    
    @IBOutlet weak var modernSearchBar: ModernSearchBar!
    var suggestionList = Array<String>()
    var prediosList = [PredioModel]()
    var cellTouched = -1
    var touchHandler: ((String) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pesquisar local"
        
        self.modernSearchBar.delegateModernSearchBar = self
        self.modernSearchBar.setDatas(datas: self.suggestionList)
        
        // lista o resultado da pesquisa sem precisar começar a digitar
        self.modernSearchBar.startListingAll()
        
        // faz o teclado aparecer de imediato
        self.modernSearchBar.becomeFirstResponder()
    }
    
    internal func onClickItemSuggestionsView(item: String) {
        print("clicou no \(item)")
        if self.touchHandler != nil {
            self.touchHandler!(item)
        }
        _ = navigationController?.popViewController(animated: true)
    }
}
