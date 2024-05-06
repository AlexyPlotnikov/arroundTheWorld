//
//  UnsplashPhotos.swift
//  ArroundTheWorld
//
//  Created by Алексей on 29.04.2024.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let unsplashPhotos = try? JSONDecoder().decode(UnsplashPhotos.self, from: jsonData)

import Foundation

// MARK: - UnsplashPhotos
struct UnsplashPhotos: Codable {
    let total, totalPages: Int?
    let results: [ResultPhoto]?

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct ResultPhoto: Codable {
    let urls: Urls?
}


struct Urls: Codable {
    let raw, full, regular, small: String?
    let thumb, smallS3: String?

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
