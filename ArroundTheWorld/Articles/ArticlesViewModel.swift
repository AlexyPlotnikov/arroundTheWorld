//
//  ArticlesViewModel.swift
//  ArroundTheWorld
//
//  Created by Алексей on 10.12.2023.
//

import Foundation
import UIKit

protocol ArticlesNavigation : AnyObject{
    func pushNavVC(NC:UINavigationController)
}

class ArticlesViewModel{
    weak var navigation : ArticlesNavigation!
    var currentPage = 1
    
    init(navigationController : ArticlesNavigation) {
        self.navigation = navigationController
        NotificationCenter.default.addObserver(self, selector: #selector(geoReloaded), name: Notification.Name("reloadGeo"), object: nil)
    }
    
    @objc func geoReloaded(){
        self.reloadArticles()
    }
    
    @objc func reloadArticles(){
        ModelManager.shared.loadArticles(byPage: self.currentPage)
    }
    
}
