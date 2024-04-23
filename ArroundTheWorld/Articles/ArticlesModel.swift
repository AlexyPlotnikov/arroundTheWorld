//
//  ArticlesModel.swift
//  ArroundTheWorld
//
//  Created by Алексей on 10.12.2023.
//

import Foundation


// MARK: - Artciles
struct Artciles: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    var results: [ResultArticles]?
}

// MARK: - Result
struct ResultArticles: Codable {
    let id, publicationDate: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case id
        case publicationDate = "publication_date"
        case title
    }
}
