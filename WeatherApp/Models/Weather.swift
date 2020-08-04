//
//  Weather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let weatherDescription: [WeatherDescription]
    let mainWeatherData: MainWeatherData

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "weather"
        case mainWeatherData = "main"
    }
}

struct WeatherDescription: Codable {
    let conditionID: Int
    let weatherDescription: String
    
    enum CodingKeys: String, CodingKey {
        case conditionID = "id"
        case weatherDescription = "description"
    }
}

struct MainWeatherData: Codable {
    let currentTemperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case pressure
        case humidity
    }
}

struct WeatherData {
    let city: String
    let parameters: MainWeatherData
    let icon: String
    let description: String
}
