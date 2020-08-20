//
//  Weather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct CurrentWeatherResponse: Decodable, WeatherResponseProtocol {
    
    let currentWeatherList: [CurrentWeather]

    enum CodingKeys: String, CodingKey {
        case currentWeatherList = "list"
    }
}
