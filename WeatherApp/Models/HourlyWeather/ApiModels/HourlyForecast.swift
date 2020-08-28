//
//  HourlyWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 11/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct HourlyForecast: Decodable {
    
    let dateTime: Int
    let temperatureParameters: TemperatureParameters
    let weather: [WeatherDescription]
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case temperatureParameters = "main"
        case weather = "weather"
    }
}
