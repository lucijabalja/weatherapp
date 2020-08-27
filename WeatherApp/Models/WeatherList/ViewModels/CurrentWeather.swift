//
//  CityWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct CurrentWeather {
    
    let city: String
    let parameters: CurrentTemperature
    let condition: Condition
    
    init(from currentWeatherEntity: CurrentWeatherEntity) {
        self.city = currentWeatherEntity.city
        self.condition = Condition(icon:  Utils.resolveWeatherIcon(Int(currentWeatherEntity.weatherDescription.conditionID)),
                                   conditionDescription: currentWeatherEntity.weatherDescription.conditionDescription)
        
        self.parameters = CurrentTemperature(now: Utils.getFormattedTemperature(currentWeatherEntity.parameters.current),
                                             min: Utils.getFormattedTemperature(currentWeatherEntity.parameters.min),
                                             max: Utils.getFormattedTemperature(currentWeatherEntity.parameters.max))
    }
    
}
