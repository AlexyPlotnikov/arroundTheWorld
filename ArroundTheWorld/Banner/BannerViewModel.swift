//
//  BannerViewModel.swift
//  ArroundTheWorld
//
//  Created by Алексей on 18.10.2023.
//

import Foundation
import UIKit

protocol BannerNavigation : AnyObject{
    func pushDetail<T: Codable>(model: T, type:DetailTypeEnum)
    func pushNavVC(NC: UINavigationController)
    func pushCity()
    func pushSearchTicket()
}

class BannerViewModel{
    weak var navigation : BannerNavigation!

   
    init(navigationController : BannerNavigation) {
        self.navigation = navigationController
        
        }
}
