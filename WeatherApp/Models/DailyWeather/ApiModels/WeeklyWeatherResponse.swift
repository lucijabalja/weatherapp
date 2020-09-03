//
//  DailyWeatherResponse.swift
//  WeatherApp
//
//  Created by Lucija Balja on 14/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct WeeklyWeatherResponse: Decodable {
    
    let dailyForecast: [DailyForecast]
    let hourlyForecast: [HourlyForecast]
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case dailyForecast = "daily"
        case hourlyForecast = "hourly"
        case latitude = "lat"
        case longitude = "lon"
    }
    
}
