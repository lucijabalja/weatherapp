//
//  ParsingService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 11/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class ParsingService {
    
    private let decoder = JSONDecoder()
    
    func parseCurrentWeather(_ data: Data) -> CurrentWeatherResponse? {
        try? decoder.decode(CurrentWeatherResponse.self, from: data)
    }
    
    func parseHourlyWeather(_ data: Data, city: String) -> HourlyWeatherResponse? {
        try? decoder.decode(HourlyWeatherResponse.self, from: data)
    }
    
    func parseDailyWeather(_ data: Data) -> DailyWeatherResponse? {
        try? decoder.decode(DailyWeatherResponse.self, from: data)
    }
    
}
