//
//  CityWeather.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class CityWeather: WeatherResponseProtocol {
    
    let city: String
    let parameters: WeatherParameters
    let icon: String
    let description: String
    
    init(city: String, parameters: WeatherParameters, icon: String, description: String) {
        self.city = city
        self.parameters = parameters
        self.icon = icon
        self.description = description
    }

}
