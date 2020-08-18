//
//  DataRepository.swift
//  WeatherApp
//
//  Created by Lucija Balja on 18/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class DataRepository {
    
    let weatherApiService: WeatherApiService
    let coreDataService: CoreDataService
    
    init(weatherApiService: WeatherApiService, coreDataService: CoreDataService) {
        self.weatherApiService = weatherApiService
        self.coreDataService = coreDataService
    }
    
    func fetchCurrentWeather(for cities: [City], completion: @escaping (WeatherApiResponse) -> Void) {
        weatherApiService.fetchCurrentWeather(for: cities) { (apiResponse) in
            switch apiResponse {
            case .SUCCESSFUL(let cityWeather):
                self.coreDataService.saveData(cityWeather: cityWeather as! CityWeather)
                completion(.SUCCESSFUL(data: cityWeather))
                
            case .FAILED(let error):
                completion(.FAILED(error: error))
            }
        }
    }
    
    func fetchCurrentWeather(for city: String, completion: @escaping (WeatherApiResponse) -> Void)  {
        
    }
    
}
