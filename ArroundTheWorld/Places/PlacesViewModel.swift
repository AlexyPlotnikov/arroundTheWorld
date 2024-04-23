//
//  PlacesViewModel.swift
//  ArroundTheWorld
//
//  Created by Алексей on 08.10.2023.
//

import Foundation


protocol PlacesNavigation : AnyObject{
    func pushDetail<T: Codable>(model: T, type:DetailTypeEnum)
}

class PlacesViewModel{
    
    weak var navigation : PlacesNavigation!
    var currentPage = 1
  
    init(navigationController : PlacesNavigation) {
        self.navigation = navigationController
        NotificationCenter.default.addObserver(self, selector: #selector(geoReloaded), name: Notification.Name("reloadGeo"), object: nil)
    //    self.reloadPlaces()

    }
    
    @objc func geoReloaded(){
        self.reloadPlaces()
    }
    
    func reloadPlaces(){
        ModelManager.shared.loadPlaces(byPage: self.currentPage)
    }
}
