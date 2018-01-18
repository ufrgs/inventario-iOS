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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pesquisar local"

        self.modernSearchBar.delegateModernSearchBar = self
        self.modernSearchBar.setDatas(datas: self.suggestionList)
        
    }
    
    func onClickItemSuggestionsView(item: String) {
        for predio in prediosList{
            if predio.sugestaoPredio == item{
                switch (cellTouched){
                case 0:
                    orgaoIndex = predio
                    break
                case 1:
                    predioIndex = predio
                    break
                case 2:
                    espacoFisicoIndex = predio
                    break
                default:
                    break
                }
            }
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func  didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
