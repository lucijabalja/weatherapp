//
//  DailyWeatherResponse.swift
//  WeatherApp
//
//  Created by Lucija Balja on 14/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct DailyWeatherResponse: Decodable {
    
    let dailyForecast: [DailyForecast]
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case dailyForecast = "daily"
        case latitude = "lat"
        case longitude = "lon"
    }
    
}
