//
//  AppDependenices.swift
//  WeatherApp
//
//  Created by Lucija Balja on 17/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class AppDependencies {
    
    lazy var weatherApiService: WeatherApiService = {
        WeatherApiService(parsingService: parsingService)
    }()
    
    lazy var coreDataService: CoreDataService = {
        CoreDataService(coreDataManager: coreDataManager)
    }()
    
    lazy var dataRepository: DataRepository = {
        DataRepository(weatherApiService: weatherApiService, coreDataService: coreDataService)
    }()
    
    lazy var coreDataManager: CoreDataManager = {
        CoreDataManager(modelName: "WeatherDataModel", completion: {})
    }()
    
    lazy var parsingService: ParsingService = {
        ParsingService()
    }()
    
    lazy var locationService: LocationService = {
        LocationService()
    }()
    
}
