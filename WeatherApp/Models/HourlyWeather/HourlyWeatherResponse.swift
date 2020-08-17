//
//  HourlyWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 11/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct HourlyWeatherResponse: Decodable {
    
    let hourlyForecast: [HourlyForecast]
    
    enum CodingKeys: String, CodingKey {
        case hourlyForecast = "list"
    }
    
    
    func convertToHourlyWeather(with city: String) -> HourlyWeather {
        HourlyWeather(hourlyForecast: hourlyForecast, city: city)
    }
    
}
