//
//  AppDependenices.swift
//  WeatherApp
//
//  Created by Lucija Balja on 17/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct AppDependencies {
    
    let weatherApiService = WeatherApiService(parsingService: ParsingService())
    let locationService = LocationService()
    
}
