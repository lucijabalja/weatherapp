//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 20/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct CurrentForecast: Decodable {
    
    let weatherDescription: [WeatherDescription]
    let temperatureParameters: TemperatureParameters
    let city: String
    let id: Double
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "weather"
        case temperatureParameters = "main"
        case city = "name"
        case id
    }
}
