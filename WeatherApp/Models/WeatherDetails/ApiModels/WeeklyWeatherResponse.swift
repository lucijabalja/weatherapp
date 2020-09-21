//
//  DailyWeatherResponse.swift
//  WeatherApp
//
//  Created by Lucija Balja on 14/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct WeeklyWeatherResponse: Decodable {
    
    let latitude: Double
    let longitude: Double
    let dailyForecast: [DailyForecast]
    let hourlyForecast: [HourlyForecast]
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case dailyForecast = "daily"
        case hourlyForecast = "hourly"
    }
    
}
