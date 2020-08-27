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

    func parseWeeklyWeather(_ data: Data) -> WeeklyWeatherResponse? {
        try? decoder.decode(WeeklyWeatherResponse.self, from: data)
    }
    
}
