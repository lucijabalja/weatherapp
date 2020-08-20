//
//  Weather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct CurrentWeatherResponse: Decodable, WeatherResponseProtocol {
    
    let weatherDescription: [WeatherDescription]
    let weatherParameters: WeatherParameters
    let city: String
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "weather"
        case weatherParameters = "main"
        case city = "name"
    }

}
