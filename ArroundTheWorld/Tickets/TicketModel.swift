//
//  TicketModel.swift
//  ArroundTheWorld
//
//  Created by Алексей on 23.04.2024.
//

import Foundation


struct BaseTicketElement: Codable {
    let titleWay: String?
    let imageWay: String?
    let subtitleWay: String?
    let isWeekend, isDate: Bool?
    let startDayOfWeek, endDayOfWeek:Int?
    let cityCode: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case titleWay = "title_way"
        case imageWay = "image_way"
        case subtitleWay = "subtitle_way"
        case isWeekend, isDate, startDayOfWeek, endDayOfWeek
        case cityCode = "city_code"
        case id
    }
}

typealias BaseTicket = [BaseTicketElement]

struct CityIATA: Codable {
    let nameTranslations: NameTranslations?
    let cases: Cases?
    let countryCode, code, timeZone: String?
    let name: String?
    let coordinates: Coordinates?

    enum CodingKeys: String, CodingKey {
        case nameTranslations = "name_translations"
        case cases
        case countryCode = "country_code"
        case code
        case timeZone = "time_zone"
        case name, coordinates
    }
}

// MARK: - Cases
struct Cases: Codable {
    let da, pr, ro, su: String?
    let tv, vi: String?
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let lat, lon: Double?
}

// MARK: - NameTranslations
struct NameTranslations: Codable {
    let en: String?
}

typealias Cities = [CityIATA]


struct Ticket: Codable {
    let data: [Datum]?
    let currency: String?
    let success: Bool?
}

// MARK: - Datum
struct Datum: Codable {
    let flightNumber, link, originAirport, destinationAirport: String?
    let departureAt: String?
    let airline, destination: String?
    let returnAt: String?
    let origin: String?
    let price, returnTransfers, duration, durationTo: Int?
    let durationBack, transfers: Int?

    enum CodingKeys: String, CodingKey {
        case flightNumber = "flight_number"
        case link
        case originAirport = "origin_airport"
        case destinationAirport = "destination_airport"
        case departureAt = "departure_at"
        case airline, destination
        case returnAt = "return_at"
        case origin, price
        case returnTransfers = "return_transfers"
        case duration
        case durationTo = "duration_to"
        case durationBack = "duration_back"
        case transfers
    }
}
