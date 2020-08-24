//
//  Weather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct CurrentWeatherResponse: Decodable {
    
    let currentForecastList: [CurrentForecast]

    enum CodingKeys: String, CodingKey {
        case currentForecastList = "list"
    }
}
