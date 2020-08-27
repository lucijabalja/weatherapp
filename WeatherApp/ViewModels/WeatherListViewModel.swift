//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherListViewModel {
    
    private let coordinator: Coordinator
    private let dataRepository: DataRepository
    private let cities = City.allCases
    var currentWeatherList = [CurrentWeather]()
    
    init(coordinator: Coordinator, dataRepository: DataRepository) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
    }
    
    func getCurrentWeather(completionHandler: @escaping (Result<Bool,Error>) -> Void) {
        dataRepository.getCurrentWeatherData() { (result) in
            switch result {
            case .success(let currentForecastEntity):
                self.saveCurrentWeather(from: currentForecastEntity)
                completionHandler(.success(true))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func pushToDetailView(at index: Int) {
        guard let selectedCity = currentWeatherList[safeIndex: index] else { return }
        
        coordinator.pushDetailViewController(with: selectedCity)
    }
    
    func saveCurrentWeather(from currentForecastEntity: CurrentForecastEntity) {
        for currentWeather in currentForecastEntity.currentWeather {
            let currentWeatherEntity = currentWeather as! CurrentWeatherEntity
            
            let current = CurrentWeather(from: currentWeatherEntity)
            self.currentWeatherList.append(current)
        }
    }

}
