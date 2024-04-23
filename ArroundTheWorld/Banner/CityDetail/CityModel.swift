//
//  CityModel.swift
//  ArroundTheWorld
//
//  Created by Алексей on 14.04.2024.
//

import Foundation


struct CityModel:Codable{
    var name:String?
    var slug:String?
}

enum City: String {
    case nsk = "Новосибирск"
    case msk = "Москва"
    case spb = "Санкт-Петербург"
    case kzn = "Казань"
    case nnv = "Нижний Новгород"
    case ekb = "Екатеринбург"
}
