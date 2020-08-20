//
//  Weather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
    
    let weather: [WeatherDescription]
    let temperatureParameters: TemperatureParameters
    let city: String
    
    enum CodingKeys: String, CodingKey {
        case weather = "weather"
        case temperatureParameters = "main"
        case city = "name"
    }
    
    func convertToCityWeather(with city: String) -> CityWeather {
        let weatherIcon = Utils.resolveWeatherIcon(weather[0].conditionID)

        return CityWeather(city: city, parameters: temperatureParameters, icon: weatherIcon, description: weather[0].weatherDescription)
    }
}
