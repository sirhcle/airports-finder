//
//  AirportsModel.swift
//  AirportsFinder
//
//  Created by CHERNANDER04 on 08/06/21.
//

import Foundation

// MARK: - AirportsModel
struct AirportsModel: Codable {
    var items: [Item]?

    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
}

// MARK: - Item
struct Item: Codable {
    var icao: String?
    var iata: String?
    var name: String?
    var shortName: String?
    var municipalityName: String?
    var location: Location?
    var countryCode: String?

    enum CodingKeys: String, CodingKey {
        case icao = "icao"
        case iata = "iata"
        case name = "name"
        case shortName = "shortName"
        case municipalityName = "municipalityName"
        case location = "location"
        case countryCode = "countryCode"
    }
}

// MARK: - Location
struct Location: Codable {
    var lat: Double?
    var lon: Double?

    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lon"
    }
}
