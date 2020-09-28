//
//  CityWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import RxDataSources

struct CurrentWeather: Equatable, IdentifiableType {
    typealias Identity = Int

    var identity: Int
    let city: String
    let parameters: CurrentTemperature
    let condition: Condition
    
    init(from currentWeatherEntity: CurrentWeatherEntity) {
        self.identity = Int(currentWeatherEntity.city.id)
        self.city = currentWeatherEntity.city.name
        self.condition = Condition(icon:  Utils.resolveWeatherIcon(Int(currentWeatherEntity.weatherDescription.conditionID)),
                                   conditionDescription: currentWeatherEntity.weatherDescription.conditionDescription)
        
        self.parameters = CurrentTemperature(now: Utils.formatTemperature(currentWeatherEntity.parameters.current),
                                             min: Utils.formatTemperature(currentWeatherEntity.parameters.min),
                                             max: Utils.formatTemperature(currentWeatherEntity.parameters.max))
    }
    
    static func == (lhs: CurrentWeather, rhs: CurrentWeather) -> Bool {
        lhs.city.elementsEqual(rhs.city)
    }
    
}
