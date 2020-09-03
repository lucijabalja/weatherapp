//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 27/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct DailyWeather {
    
    let dateTime: Int
    let temperature: CurrentTemperature
    let icon: String
    
    init(from dailyWeatherEntity: DailyWeatherEntity) {
        self.dateTime = Int(dailyWeatherEntity.dateTime)
        self.temperature = CurrentTemperature(now: nil,
                                             min: Utils.getFormattedTemperature(dailyWeatherEntity.temperature.min),
                                             max: Utils.getFormattedTemperature(dailyWeatherEntity.temperature.max))
        self.icon = Utils.resolveWeatherIcon(Int(dailyWeatherEntity.conditionID))
        
    }
    
}
