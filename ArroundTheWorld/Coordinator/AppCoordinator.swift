//
//  AppCoordinator.swift
//  CoordinatorTutorial
//
//  Created by BobbyPhtr on 13/04/21.
//

import Foundation
import UIKit

class AppCoordinator : Coordinator {
    var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
       goMain()
    }
    
   
    
    func goMain(){
        let chooseCoordinator = MainCoordinator.init(navigationController: navigationController)
        chooseCoordinator.parentCoordinator = self
        children.append(chooseCoordinator)
        
        chooseCoordinator.start()
    }
    
  
    deinit {
        print("AppCoordinator Deinit")
    }
    
    
   
    
}
