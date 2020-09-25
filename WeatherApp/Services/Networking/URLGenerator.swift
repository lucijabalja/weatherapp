//
//  URLGenerator.swift
//  WeatherApp
//
//  Created by Lucija Balja on 01/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class URLGenerator {
    
    static let baseURL = "https://api.openweathermap.org/data/2.5"
    static let apiKey = "appid=56151fef235e6cebb33750525932d021"
    static let units = "units=metric"
    static let exclusions = "exclude=minutely"
    
    static func currentWeather(ids: String) -> String {
        "\(baseURL)/group?\(apiKey)&\(exclusions)&\(units)&id=\(ids)"
    }
    
    static func currentCityWeather(forCity city: String) -> String {
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        return "\(baseURL)/weather?q=\(encodedCity)&\(apiKey)&\(units)"
    }
    
    static func weeklyWeather(with latitude: Double,_ longitude: Double) -> String {
        "\(baseURL)/onecall?\(apiKey)&\(units)&lat=\(latitude)&lon=\(longitude)&\(exclusions)"
    }
    
}
