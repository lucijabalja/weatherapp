//
//  HourlyWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 11/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct HourlyForecast: Decodable {
    
    let dateTime: Int
    let weatherParameteres: WeatherParameters
    let weatherDescription: [WeatherDescription]
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case weatherParameteres = "main"
        case weatherDescription = "weather"
    }
}
