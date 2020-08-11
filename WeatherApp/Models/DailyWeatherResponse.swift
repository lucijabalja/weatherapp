//
//  HourlyWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 11/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct DailyWeatherResponse: Codable {
    
    let hourlyWeather: [HourlyWeather]
    
    enum CodingKeys: String, CodingKey {
        case hourlyWeather = "list"
    }
    
    func convertToDailyWeather(with city: String) -> DailyWeather {
        return DailyWeather(hourlyWeather: hourlyWeather, city: city)
    }
    
}
