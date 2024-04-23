//
//  ArticlesDetail.swift
//  ArroundTheWorld
//
//  Created by Алексей on 10.01.2024.
//

import Foundation


// MARK: - ArticlesDetail
struct ArticlesDetail: Codable {
    let id: Int?
    let publicationDate: Int?
    let title: String?
    let items: [Item]?
    let favoritesCount, commentsCount: Int?
    let images: [ImageDetailArticle]?
    let description: String?
   

    enum CodingKeys: String, CodingKey {
        case id
        case publicationDate = "publication_date"
        case title, items
        case favoritesCount = "favorites_count"
        case commentsCount = "comments_count"
        case images, description
        
    }
}

// MARK: - Image
struct ImageDetailArticle: Codable {
    let image: String?
    let source: Source?
}

// MARK: - Source
struct Source: Codable {
    let name: String?
    let link: String?
}

// MARK: - Item
struct Item: Codable {
    let id: Int?
    let title, description: String?

    enum CodingKeys: String, CodingKey {
        case id, title, description
     

    }
}


