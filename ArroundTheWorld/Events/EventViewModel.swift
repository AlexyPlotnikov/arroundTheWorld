//
//  EventViewModel.swift
//  ArroundTheWorld
//
//  Created by Алексей on 04.02.2024.
//

import Foundation


protocol EventNavigation : AnyObject{
    func pushDetail(poster:ResultModel, type:DetailTypeEnum)
}

class EventViewModel{
    weak var navigation : EventNavigation!
    var currentPage = 1
    
    init(navigationController : EventNavigation) {
        self.navigation = navigationController
        NotificationCenter.default.addObserver(self, selector: #selector(geoReloaded), name: Notification.Name("reloadGeo"), object: nil)
    }
    
    @objc func geoReloaded(){
        self.reloadEvents()
    }
    
    @objc func reloadEvents(){
        ModelManager.shared.loadEvents(byPage: self.currentPage)
    }
    
}
