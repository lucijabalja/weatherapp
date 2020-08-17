//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 17/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class DailyWeather: WeatherResponseProtocol {
    
    let dailyForecast: [DailyForecast]
    
    init(dailyForecast: [DailyForecast]) {
        self.dailyForecast = dailyForecast
    }
}
