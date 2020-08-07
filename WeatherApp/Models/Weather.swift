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
    let weatherParameteres: WeatherParameters
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "weather"
        case weatherParameteres = "main"
    }
    
    func convertToWeatherData(with city: String) -> CityWeather {
        let weatherIcon = Utils.setWeatherIcon(weatherDescription[0].conditionID)
        return CityWeather(city: city, parameters: weatherParameteres, icon: weatherIcon, description: weatherDescription[0].weatherDescription)
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

struct WeatherParameters: Codable {
    let currentTemperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case humidity
    }
}

struct CityWeather {
    let city: String
    let parameters: WeatherParameters
    let icon: String
    let description: String
}
