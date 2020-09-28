//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 11/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct HourlyWeather {
    
    let dateTime: Int
    let temperature: String
    let icon: String
    
    init(from hourlyWeatherEntity: HourlyWeatherEntity) {
        self.dateTime = Int(hourlyWeatherEntity.time)
        self.temperature = Utils.formatTemperature(hourlyWeatherEntity.temperature)
        self.icon = Utils.resolveWeatherIcon(Int(hourlyWeatherEntity.conditionID))
    }
    
}
