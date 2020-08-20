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
    
    func parseCurrentWeather(_ data: Data, city: String) -> CurrentWeatherResponse? {
        guard let currentWeatherResponse = try? decoder.decode(CurrentWeatherResponse.self, from: data) else {
            return nil
        }

       // let cityWeather = currentWeatherResponse.convertToCityWeather(with: city)
        return currentWeatherResponse
    }
    
    func parseHourlyWeather(_ data: Data, city: String) -> HourlyWeather? {
        guard let hourlyWeatherResponse = try? decoder.decode(HourlyWeatherResponse.self, from: data) else {
            return nil
        }
        
        let dailyCityWeather = hourlyWeatherResponse.convertToHourlyWeather(with: city)
        return dailyCityWeather
    }
    
    func parseDailyWeather(_ data: Data) -> DailyWeather? {
        guard let dailyWeatherResponse = try? decoder.decode(DailyWeatherResponse.self, from: data) else {
            return nil
        }
                
        return dailyWeatherResponse.convertToDailyWeather()
    }
    
}
