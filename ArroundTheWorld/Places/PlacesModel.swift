//
//  PlacesModel.swift
//  ArroundTheWorld
//
//  Created by Алексей on 09.10.2023.
//

import Foundation


struct PlacesModel: Codable {
    let count: Int?
    let next, previous: String?
    var results: [ResultPlacesModel]?
}

// MARK: - Result
struct ResultPlacesModel: ResultModel {
    var title: String
    
    var description: String
    
    var images: [Image]
    
    var place: Place?
    
    var tags: [String]?
    
    var site_url: String?
    
    var adress:String?
    var address:String?
    var subway:String?
    var coords:Coords?
}



// MARK: - Image
struct ImagePlacesModel: Codable {
    let image: String?
    
}
