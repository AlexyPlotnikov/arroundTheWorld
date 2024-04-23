//
//  BannerModel.swift
//  ArroundTheWorld
//
//  Created by Алексей on 18.10.2023.
//

import Foundation


struct BannerModel:Codable{
    var image:[String]?
    var title:String?
    var descript:String?
    var adress:Place?
}
