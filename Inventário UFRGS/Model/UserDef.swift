//
//  UserDef.swift
//  Inventário UFRGS
//
//  Created by Lucas Flores on 28/09/17.
//  Copyright © 2017 CPD UFRGS. All rights reserved.
//

import Foundation

class UserDef: NSObject {
    
    static func saveToken(_ token: String){
        let saveTk = UserDefaults.standard
        saveTk.set(token, forKey: "token")
        saveTk.synchronize()
    }
    
    static func getToken() -> String{
        let getTk = UserDefaults.standard.object(forKey: "token")
        if getTk != nil {
            return getTk as! String
        }
        else {
            return "nil"
        }
    }
    
    static func deleteToken(){
        let deleteTk = UserDefaults.standard
        deleteTk.removeObject(forKey: "token")
        deleteTk.synchronize()
    }

}
