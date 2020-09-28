//
//  CurrentWeatherDetails.swift
//  WeatherApp
//
//  Created by Lucija Balja on 28/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct CurrentWeatherDetails: Decodable {
    
    let sunrise: Int64
    let sunset: Int64
    let feelsLike: Double
    let humidity: Int64
    let pressure: Int64
    let visibility: Int64
    
    enum CodingKeys: String, CodingKey {
        case sunrise
        case sunset
        case feelsLike = "feels_like"
        case humidity
        case pressure
        case visibility
    }
    
}
