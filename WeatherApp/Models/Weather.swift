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
    let city: String
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "weather"
        case weatherParameteres = "main"
        case city = "name"
    }
    
    func convertToCityWeather(with city: String) -> CityWeather {
        let weatherIcon = Utils.resolveWeatherIcon(weatherDescription[0].conditionID)
        
        return CityWeather(city: city, parameters: weatherParameteres, icon: weatherIcon, description: weatherDescription[0].weatherDescription)
    }
}
