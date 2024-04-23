//
//  PlacesViewModel.swift
//  ArroundTheWorld
//
//  Created by Алексей on 07.10.2023.
//

import Foundation


protocol MainNavigation : AnyObject{
   
}

class MainViewModel{
    weak var navigation : MainNavigation!
    var segmentTitles = ["афиша", "билеты", "статьи", "места", "мероприятия"]
    var currentSelectedindex = 0
    
    init(navigationController : MainNavigation) {
            self.navigation = navigationController
        }
}
