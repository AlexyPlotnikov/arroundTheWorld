//
//  PosterViewModel.swift
//  ArroundTheWorld
//
//  Created by Алексей on 23.10.2023.
//

import Foundation
import UIKit


protocol PosterNavigation : AnyObject{
    func pushDetail(poster:ResultModel, type:DetailTypeEnum)
    func pushNavVC(NC:UINavigationController)
}

class PosterViewModel{
    weak var navigation : PosterNavigation!
 
    
    init(navigationController : PosterNavigation) {
        self.navigation = navigationController
       
    }
    

    
}
