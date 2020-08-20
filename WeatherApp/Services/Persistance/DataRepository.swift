//
//  DataRepository.swift
//  WeatherApp
//
//  Created by Lucija Balja on 18/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import Reachability

class DataRepository {
    
    let weatherApiService: WeatherApiService
    let coreDataService: CoreDataService
    let reachability: Reachability
    
    init(weatherApiService: WeatherApiService, coreDataService: CoreDataService, reachability: Reachability) {
        self.weatherApiService = weatherApiService
        self.coreDataService = coreDataService
        self.reachability = reachability
        
        startReachabilityNotifier()
    }
    
    func getCurrentCityWeather(completion: @escaping ([CityWeather]) -> Void) {
        var cityWeatherEntitiesArray = [CityWeatherEntity]()
        var cityWeatherArray = [CityWeather]()
        
        reachability.whenReachable = { _ in
            self.weatherApiService.fetchCurrentWeather(completion: { (result) in
                if case let Result.success(currentWeatherList) = result {
                    self.coreDataService.saveCurrentWeatherData(currentWeatherList)
                    cityWeatherEntitiesArray = self.coreDataService.loadCurrentWeatherData()
                    cityWeatherArray = self.convertToCityWeather(cityWeatherEntities: cityWeatherEntitiesArray)
                    completion(cityWeatherArray)
                }
            })
        }
        
        reachability.whenUnreachable = { _ in
            cityWeatherEntitiesArray = self.coreDataService.loadCurrentWeatherData()
            cityWeatherArray = self.convertToCityWeather(cityWeatherEntities: cityWeatherEntitiesArray)
            completion(cityWeatherArray)
        }
        print(reachability.connection.description)
    }

    func convertToCityWeather(cityWeatherEntities: [CityWeatherEntity]) -> [CityWeather] {
        var cityWeatherArray = [CityWeather]()
        for cityWeatherEntity in cityWeatherEntities {
            let params = cityWeatherEntity.parameters!
            let temperatureParams = CurrentTemperature(current: params.current!, min: params.min!, max: params.max!)
            
            let cityWeather = CityWeather(city: cityWeatherEntity.city!, parameters: temperatureParams, icon: cityWeatherEntity.icon!, description: cityWeatherEntity.weatherDescription!)
            
            cityWeatherArray.append(cityWeather)
        }
        
        return cityWeatherArray
    }
    
    func startReachabilityNotifier() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
