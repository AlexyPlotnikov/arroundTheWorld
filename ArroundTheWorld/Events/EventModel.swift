//
//  EventModel.swift
//  ArroundTheWorld
//
//  Created by Алексей on 04.02.2024.
//

import Foundation

protocol ResultModel:Codable {
    var title: String { get }
    var description: String { get }
    var images: [Image] { get }
    var place:Place? { get }
    var tags:[String]? { get }
    var site_url:String? { get }
}

struct EventModel: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    var results: [Result]?
}

struct Result: ResultModel {
    var site_url: String?
    var tags: [String]?
    var place: Place?
    let title: String
    let description: String
    let images: [Image]
    let dates:[Dates]?

}

struct Dates:Codable{
    var start_date:String?
}

struct Image: Codable {
    let image: String
}

struct LocationEvent: Codable {
    let slug: String
    let name: String
    let timezone: String
    let coords: Coords
    let language: String
    let currency: String
}

struct Coords: Codable {
    let lat, lon: Double?
}

struct Place: Codable {
    let id: Int?
    let title, slug, address, phone: String?
    let subway: String?
    let location: String?
    let siteURL: String?
    let isClosed: Bool?
    let coords: Coords?
    let isStub: Bool?
}

