//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 11/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class HourlyWeather: WeatherResponseProtocol {
    
    let hourlyForecast: [HourlyForecast]
    let city: String
    
    init(hourlyForecast: [HourlyForecast], city: String) {
        self.hourlyForecast = hourlyForecast
        self.city = city
    }
    
}
