//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 20/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct CurrentWeather: Decodable {
    
    let weatherDescription: [WeatherDescription]
    let weatherParameters: TemperatureParameters
    let city: String
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "weather"
        case weatherParameters = "main"
        case city = "name"
    }
    
}
