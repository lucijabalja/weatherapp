//
//  AppDependenices.swift
//  WeatherApp
//
//  Created by Lucija Balja on 17/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct AppDependencies {
    
    let weatherApiService: WeatherApiService
    let locationService: LocationService
    let coreDataService: CoreDataService
    let dataRepository: DataRepository
    
    init() {
        weatherApiService = WeatherApiService(parsingService: ParsingService())
        locationService = LocationService()
        coreDataService = CoreDataService()
        dataRepository = DataRepository(weatherApiService: weatherApiService, coreDataService: coreDataService)
    }
    
}
