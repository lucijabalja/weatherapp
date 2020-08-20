//
//  WeatherParameters.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct WeatherParameters: Decodable {
    
    let currentTemperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
    }
}
