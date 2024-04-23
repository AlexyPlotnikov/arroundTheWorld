//
//  DetailViewModel.swift
//  ArroundTheWorld
//
//  Created by Алексей on 16.12.2023.
//

import Foundation
import UIKit

protocol DetailNavigation : AnyObject{
   func back()
}

class DetailViewModel{
    weak var navigation : DetailNavigation!
    var images:[String] = []
    var titleText:String = ""
    var descriptionText:String = ""
    var adress:String = ""
    var tags:[String] = []
    var coords:Coords?
    var site:String = ""
    var imagesURLs:[URL] = []
    
    init(navigationController : DetailNavigation) {
        self.navigation = navigationController
    }
    
    func processModel<T: Codable>(model: T, type:DetailTypeEnum) {
        switch type {
        case .banner:
            let tempModel = (model as! BannerModel)
           
            self.images = tempModel.image!
            self.titleText = tempModel.title!
            self.descriptionText = tempModel.descript!
           
            
        case .poster:
            let tempModel = (model as! ResultModel)
            for image in tempModel.images{
                self.images.append(image.image)
                self.imagesURLs.append(URL(string: image.image)!)
            }
            print(tempModel)
            self.titleText = tempModel.title
            self.descriptionText = tempModel.description
            self.adress = tempModel.place?.address ?? ""
            if(tempModel.place?.subway != nil && tempModel.place?.subway != ""){
               
                self.adress = self.adress + " м. " + tempModel.place!.subway!
            }
            self.tags = tempModel.tags ?? []
            self.coords = tempModel.place?.coords
            self.site = tempModel.site_url ?? ""
            
        case .place:
            let tempModel = (model as! ResultPlacesModel)
            for image in tempModel.images{
                self.images.append(image.image)
                self.imagesURLs.append(URL(string: image.image)!)
            }
            print(tempModel)
            self.titleText = tempModel.title
            self.descriptionText = tempModel.description
            self.adress = tempModel.address ?? ""
            if(tempModel.place?.subway != nil && tempModel.place?.subway != ""){
                self.adress = self.adress + " м. " + tempModel.subway!
            }
            self.tags = tempModel.tags ?? []
            self.coords = tempModel.coords
            self.site = tempModel.site_url ?? ""
        }
    }
}
