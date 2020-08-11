//
//  ParsingService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 11/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class ParsingService {
    
    let decoder = JSONDecoder()
    
    func parseCityWeather(_ data: Data, city: String) -> CityWeather? {
        guard let currentWeatherResponse = try? decoder.decode(Weather.self, from: data) else {
            return nil
        }

        let cityWeather = currentWeatherResponse.convertToCityWeather(with: city)
        return cityWeather
    }
    
    func parseDailyWeather(_ data: Data, city: String) -> DailyWeather? {
        guard let dailyWeatherResponse = try? decoder.decode(DailyWeatherResponse.self, from: data) else {
            return nil
        }
        
        let dailyCityWeather = dailyWeatherResponse.convertToDailyWeather(with: city)
        return dailyCityWeather
    }
    
}
