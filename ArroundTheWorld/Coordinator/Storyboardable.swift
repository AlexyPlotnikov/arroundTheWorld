//
//  Storybordable.swift
//  AskoMed
//
//  Created by RX Group on 13.03.2023.
//

import Foundation
import UIKit



protocol Storyboardable {
    static func createMain(with identifire:String) -> Self
    static func createSearch(with identifire:String) -> Self
   
}

extension Storyboardable where Self: UIViewController {
    
    static func createMain(with identifire:String) -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifire) as! Self
    }
    
    static func createSearch(with identifire:String) -> Self{
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifire) as! Self
    }
    
   
}
