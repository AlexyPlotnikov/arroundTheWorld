//
//  TicketViewModel.swift
//  ArroundTheWorld
//
//  Created by Алексей Плотников on 22.04.2024.
//

import Foundation

protocol TicketNavigation : AnyObject{
  
}

class TicketViewModel{
    weak var navigation : TicketNavigation!
    var decodedCities:Cities!
    
    init(navigationController : TicketNavigation) {
        self.navigation = navigationController
       
    }
    

    
}
