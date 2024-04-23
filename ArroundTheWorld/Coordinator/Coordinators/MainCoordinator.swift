//
//  ChooseCoordinator.swift
//  AskoMed
//
//  Created by RX Group on 14.03.2023.
//

import Foundation
import UIKit

class MainCoordinator:Coordinator{
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    
    
    func start() {
        self.startMain()
    }
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(firstLoad), name: Notification.Name("reloadGeo"), object: nil)
    }
   
    func startMain(){
        LocationService.shared.startUpdatingLocation()
       
    }
    
    @objc func firstLoad(){
        DispatchQueue.main.async{
            if (self.navigationController.viewControllers.count) > 0{
                self.navigationController.viewControllers.remove(at: 0)
            }
            ModelManager.shared.loadCount = 0
            ModelManager.shared.firstLoad()
            let bannerVC = BannerController.createMain(with: "bannerVC")
            let viewModel = BannerViewModel.init(navigationController: self)
            bannerVC.viewModel = viewModel
            
            self.navigationController.pushViewController(bannerVC, animated: false)
        }
    }
}



extension MainCoordinator:MainNavigation, BannerNavigation, DetailNavigation{
    func pushCity() {
        let pvc = CityController.createMain(with: "cityVC")
        if #available(iOS 15.0, *) {
            if let sheet = pvc.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.__preferredCornerRadius = 0
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.prefersEdgeAttachedInCompactHeight = true
            }
        } else {
            // Fallback on earlier versions
        }
        self.navigationController.present(pvc, animated: false, completion: nil)
    }
    
    func pushNavVC(NC: UINavigationController) {
        NC.modalPresentationStyle = .fullScreen
        navigationController.present(NC, animated: true)
    }
    
    func pushDetail<T>(model: T, type: DetailTypeEnum) where T : Decodable, T : Encodable {
        let detail = DetailController.createMain(with: "detailVC")
        let viewModel = DetailViewModel.init(navigationController: self)
        detail.viewModel = viewModel
        detail.viewModel.processModel(model: model, type: type)
        
        navigationController.pushViewController(detail, animated: true)
    }
    
    func back() {
        self.navigationController.popViewController(animated: true)
    }
}


extension MainCoordinator:PlacesNavigation{
   
    
}
