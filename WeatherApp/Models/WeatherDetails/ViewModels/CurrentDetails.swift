//
//  CurrentDetails.swift
//  WeatherApp
//
//  Created by Lucija Balja on 28/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct CurrentDetails {
    
    let sunrise: Int64
    let sunset: Int64
    let feelsLike: Double
    let humidity: Int64
    let pressure: Int64
    let visibility: Int64
    
    init(from currentDetailsEntity: CurrentDetailsEntity) {
        self.sunrise = currentDetailsEntity.sunrise
        self.sunset = currentDetailsEntity.sunset
        self.feelsLike = currentDetailsEntity.feelsLike
        self.humidity = currentDetailsEntity.humidity
        self.pressure = currentDetailsEntity.pressure
        self.visibility = currentDetailsEntity.visibility
    }
    
}
