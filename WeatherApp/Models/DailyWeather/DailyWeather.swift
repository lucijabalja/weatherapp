//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 14/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct DailyWeather: Decodable {
    
    let dateTime: Int
    let temperature: Temperature
    let weatherDescription: [WeatherDescription]
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case temperature = "temp"
        case weatherDescription = "weather"
    }
}
